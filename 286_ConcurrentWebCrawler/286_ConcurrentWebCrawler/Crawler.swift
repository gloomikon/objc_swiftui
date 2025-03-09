import Foundation

actor Queue {

    private var items: Set<URL> = []
    private var inProgress: Set<URL> = []

    private var seen: Set<URL> = []

    private var pending: [() -> Void] = []

    func dequeue() async -> URL? {
        if Task.isCancelled { return nil }
        if let result = items.popFirst() {
            inProgress.insert(result)
            return result
        } else if done {
            return nil
        } else {
            await withCheckedContinuation { continuation in
                pending.append(continuation.resume)
            }
            return await dequeue()
        }
    }

    func finish(_ item: URL) {
        inProgress.remove(item)
        if done {
            flushPending()
        }
    }

    private var done: Bool {
        items.isEmpty && inProgress.isEmpty
    }

    func add(newItems: [URL]) {
        let newItems = newItems.filter { !seen.contains($0) }
        seen.formUnion(newItems)
        items.formUnion(newItems)
        flushPending()
    }

    fileprivate func flushPending() {
        for continuation in pending {
            continuation()
        }
        pending.removeAll()
    }
}

typealias CrawlerStream = AsyncThrowingStream<Page, Error>

fileprivate func crawl(
    url: URL,
    continuation: CrawlerStream.Continuation
) async throws {
    let basePrefix = url.absoluteString

    let queue = Queue()
    await queue.add(newItems: [url])
    try await withThrowingTaskGroup(of: Void.self) { group in
        for i in 0..<4 {
            group.addTask {
                var numberOfJobs = 0
                while let job = await queue.dequeue() {
                    let page = try await URLSession.shared.page(from: job)
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC*10)
                    let newURLs = page.outgoingLinks.filter { url in
                        url.absoluteString.hasPrefix(basePrefix)
                    }
                    await queue.add(newItems: newURLs)
                    continuation.yield(page)
                    await queue.finish(page.url)
                    numberOfJobs += 1
                }
                print("Worker \(i) did \(numberOfJobs) jobs")
            }
        }

        do {
            for try await _ in group {

            }
        } catch {
            await queue.flushPending()
            throw error
        }
    }
}

func crawl(url: URL) -> CrawlerStream {
    CrawlerStream { continuation in
        let task = Task {
            do {
                try await crawl(url: url, continuation: continuation)
                continuation.finish(throwing: nil)
            } catch {
                continuation.finish(throwing: error)
            }
        }
        continuation.onTermination = { @Sendable _ in
            print("onTermination")
            task.cancel()
        }
    }
}

extension URLSession {
    func page(from url: URL) async throws -> Page {
        let (data, _) = try await data(from: url)
        let doc = try XMLDocument(data: data, options: .documentTidyHTML)
        let title = try doc.nodes(forXPath: "//title").first?.stringValue
        let links: [URL] = try doc.nodes(forXPath: "//a[@href]").compactMap { node in
            guard let el = node as? XMLElement else { return nil }
            guard let href = el.attribute(forName: "href")?.stringValue else { return nil }
            return URL(string: href, relativeTo: url)?.simplified
        }
        return Page(url: url, title: title ?? "", outgoingLinks: links)
    }
}

extension URL {
    var simplified: URL {
        var result = absoluteString
        if let i = result.lastIndex(of: "#") {
            result = String(result[..<i])
        }
        if result.last == "/" {
            result.removeLast()
        }
        return URL(string: result)!
    }
}

struct Page {
    var url: URL
    var title: String
    var outgoingLinks: [URL]
}
