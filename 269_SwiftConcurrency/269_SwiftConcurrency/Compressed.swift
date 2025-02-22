import Foundation

struct Compressed<Base: AsyncSequence>: AsyncSequence where Base.Element == Data {

    typealias Element = Data

    let base: Base
    let method: Compressor.Method

    struct AsyncIterator: AsyncIteratorProtocol {

        var base: Base.AsyncIterator
        let compressor: Compressor

        mutating func next() async throws -> Data? {
            guard let data = try await base.next() else {
                let result = try compressor.eof()
                return result.isEmpty ? nil : result
            }
            return try compressor.compress(data)
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base: base.makeAsyncIterator(), compressor: Compressor(method: method))
    }
}

extension AsyncSequence where Element == Data {

    var compressed: Compressed<Self> {
        Compressed(base: self, method: .compress)
    }

    var decompressed: Compressed<Self> {
        Compressed(base: self, method: .decompress)
    }
}
