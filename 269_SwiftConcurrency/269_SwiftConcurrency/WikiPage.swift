struct Page {

    let title: String
    let id: String
}

extension AsyncIteratorProtocol where Element == XMLEvent {

    mutating func parsePage() async  throws -> Page? {
        while let event = try await next() {
            switch event {
            case .didStart("page"):
                return try await parsePageContents()
            case .didStart:
                continue
            case .didEnd:
                continue
            case .foundCharacters:
                continue
            }
        }
        return nil
    }

    private mutating func parsePageContents() async throws -> Page {
        var title: String?
        var id: String?
        while let event = try await next() {
            switch event {
            case .didStart("title"):
                title = try await parseCharacters(until: "title")
            case .didStart("id"):
                id = try await parseCharacters(until: "id")
            case .didStart(let name):
                try await parseChildren(until: name)
            case .didEnd("page"):
                guard let title, let id else {
                    throw ParseError()
                }
                return Page(title: title, id: id)
            case .foundCharacters:
                continue
            default:
                throw ParseError()
            }
        }
        throw ParseError()
    }

    private mutating func parseCharacters(until tag: String) async throws -> String {
        var result = ""

        while let event = try await next() {
            switch event {
            case .didEnd(tag):
                return result
            case .foundCharacters(let c):
                result += c
            default:
                throw ParseError()
            }
        }

        throw ParseError()
    }

    private mutating func parseChildren(until tag: String) async throws {
        while let event = try await next() {
            switch event {
            case .didStart(let name):
                try await parseChildren(until: name)
            case .didEnd(tag):
                return
            case .foundCharacters:
                continue
            default:
                throw ParseError()
            }
        }
    }
}

struct ParseError: Error {

}

struct Pages<Base: AsyncSequence>: AsyncSequence where Base.Element == XMLEvent {

    typealias Element = Page

    let base: Base

    struct AsyncIterator: AsyncIteratorProtocol {

        var base: Base.AsyncIterator

        mutating func next() async throws -> Element? {
            try await base.parsePage()
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base: base.makeAsyncIterator())
    }
}

extension AsyncSequence where Element == XMLEvent {

    var pages: Pages<Self> {
        Pages(base: self)
    }
}
