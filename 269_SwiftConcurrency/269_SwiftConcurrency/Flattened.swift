import Foundation

struct Flattened<Base: AsyncSequence>: AsyncSequence where Base.Element: Sequence {

    typealias Element = Base.Element.Element

    let base: Base

    struct AsyncIterator: AsyncIteratorProtocol {

        var base: Base.AsyncIterator
        var buffer: Base.Element.Iterator?

        mutating func next() async throws -> Element? {
            if let element = buffer?.next() {
                return element
            }
            buffer = try await base.next()?.makeIterator()
            if buffer == nil { return nil }
            return try await next()
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base: base.makeAsyncIterator())
    }
}

extension AsyncSequence where Element: Sequence {

    var flattened: Flattened<Self> {
        Flattened(base: self)
    }
}
