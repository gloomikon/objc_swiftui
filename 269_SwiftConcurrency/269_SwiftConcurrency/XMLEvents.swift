import Foundation

struct XMLEvents<Base: AsyncSequence>: AsyncSequence where Base.Element == Data {

    typealias Element = XMLEvent

    let base: Base

    struct AsyncIterator: AsyncIteratorProtocol {

        var base: Base.AsyncIterator

        init(base: Base.AsyncIterator) {
            self.base = base
        }


        private let parser = PushParser()
        private var buffer: [XMLEvent] = []

        mutating func next() async throws -> XMLEvent? {
            if !buffer.isEmpty {
                return buffer.removeFirst()
            }

            guard let data = try await self.base.next() else {
                parser.finish()
                return nil
            }

            var newEvents: [XMLEvent] = []
            parser.onEvent = { event in
                newEvents.append(event)
            }
            parser.process(data)
            buffer = newEvents

            return try await next()
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base: base.makeAsyncIterator())
    }
}

extension AsyncSequence where Element == Data {

    var xmlEvents: XMLEvents<Self> {
        XMLEvents(base: self)
    }
}
