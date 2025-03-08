import Foundation

@MainActor
final class DownloadModel: ObservableObject, Sendable {
    let url: URL
    init(_ url: URL) {
        self.url = url
    }
    
    enum State {
        case notStarted
        case started
        case paused(resumeData: Data?)
        case done(URL)
    }
    
    @Published var state = State.notStarted
    @Published var progress: (bytesWritten: Int64, bytesExpected: Int64)?

    private var delegate = DownloadModelDelegate()

    private var downloadTask: URLSessionDownloadTask?

    func start() async {
        let task: URLSessionDownloadTask =
        if case let .paused(data?) = state {
            URLSession.shared.downloadTask(withResumeData: data)
        } else {
            URLSession.shared.downloadTask(with: url)
        }

        state = .started

        task.delegate = delegate
        task.resume()
        downloadTask = task

        let stream = AsyncStream<DownloadModelDelegate.Event> { continuation in
            delegate.onEvent = { event in
                continuation.yield(event)

                switch event {
                case .didCancel, .didFinish:
                    continuation.finish()
                default:
                    break
                }
            }
        }

        for await event in stream {
            switch event {
            case .didCancel:
                ()
            case .didFinish(let url):
                state = .done(url)
            case .didWrite(let bytesWritten, let bytesExpected):
                progress = (bytesWritten: bytesWritten, bytesExpected: bytesExpected)
            }
        }

        print("Finished")
    }

    func pause() async {
        let data = await downloadTask?.cancelByProducingResumeData()
        state = .paused(resumeData: data)
    }
}

//extension URLSessionDownloadTask {
//    func cancel() async -> Data? {
//        await withCheckedContinuation { cont in
//            self.cancel(byProducingResumeData: { data in
//                cont.resume(returning: data)
//            })
//        }
//    }
//}

final class DownloadModelDelegate: NSObject, URLSessionDownloadDelegate {

    enum Event {
        case didFinish(URL)
        case didWrite(bytesWritten: Int64, bytesExpected: Int64)
        case didCancel
    }

    var onEvent: (Event) -> () = { _ in }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        onEvent(.didFinish(location))
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: (any Error)?
    ) {
        if let error = error as? NSError, error.code == CFNetworkErrors.cfurlErrorCancelled.rawValue {
            onEvent(.didCancel)
        }
    }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        onEvent(.didWrite(
            bytesWritten: totalBytesWritten,
            bytesExpected: totalBytesExpectedToWrite
        ))
    }
}
