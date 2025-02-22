import Foundation

struct Chunked<Base: AsyncSequence>: AsyncSequence where Base.Element == UInt8 {

    typealias Element = Data

    let base: Base
    var chunkSize: Int = Compressor.bufferSize

    struct AsyncIterator: AsyncIteratorProtocol {

        var base: Base.AsyncIterator
        let chunkSize: Int

        mutating func next() async throws -> Data? {
            var result = Data()
            while let element = try await base.next() {
                result.append(element)
                if result.count == chunkSize { return result }
            }
            return result.isEmpty ? nil : result
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base: base.makeAsyncIterator(), chunkSize: chunkSize)
    }
}

extension AsyncSequence where Element == UInt8 {

    var chunked: Chunked<Self> {
        Chunked(base: self)
    }
}
