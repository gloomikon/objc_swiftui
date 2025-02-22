import Foundation

/*
func sample() async throws {
    let start = Date.now
    let url = Bundle.main.url(forResource: "enwik8", withExtension: "xml")!
    let str = try String(contentsOf: url)
    var counter = 0
    str.enumerateLines { line, stop in
        counter += 1
    }
    print(counter)
    print("Duration: \(Date.now.timeIntervalSince(start))")
}
*/

/*
func sample() async throws {
    let start = Date.now
    let url = Bundle.main.url(forResource: "enwik8", withExtension: "xml")!

    var counter = 0

    let fileHandle = try FileHandle(forReadingFrom: url)
    for try await _ in fileHandle.bytes.lines {
        counter += 1
    }

    print(counter)
    print("Duration: \(Date.now.timeIntervalSince(start))")
}
 */

/*
func sample() async throws {
    let start = Date.now
    let url = Bundle.main.url(forResource: "enwik8", withExtension: "zlib")!
    let fileHandle = try FileHandle(forReadingFrom: url)
    for try await page in fileHandle.bytes.chunked.decompressed.xmlEvents.pages {
        print(page)
    }
    print("Duration: \(Date.now.timeIntervalSince(start))")
}
*/

/*
func sample() async throws {
    let start = Date.now
    let (bytes, _) = try await URLSession.shared.bytes(from: URL(string: "https://d2sazdeahkz1yk.cloudfront.net/sample/enwik8.zlib")!)
    for try await page in bytes.chunked.decompressed.xmlEvents.pages {
        print(page)
    }
    print("Duration: \(Date.now.timeIntervalSince(start))")
}
 */

/*
func stream(at url: URL) -> AsyncStream<Data> {
    AsyncStream { continuation in
        let file = fopen(url.path, "r")
        let buffer = UnsafeMutableRawPointer.allocate(
            byteCount: Compressor.bufferSize,
            alignment: 1
        )

        while true {
            let count = fread(buffer, 1, Compressor.bufferSize, file)
            if count == 0 { break }
            continuation.yield(Data(bytes: buffer, count: count))
        }

        fclose(file)
        buffer.deallocate()
        continuation.finish()
    }
}
*/

func stream(at url: URL) -> AsyncStream<Data> {
    let file = fopen(url.path, "r")
    let buffer = UnsafeMutableRawPointer.allocate(
        byteCount: Compressor.bufferSize,
        alignment: 1
    )

    func close() {
        fclose(file)
        buffer.deallocate()
    }

    return AsyncStream {
        let count = fread(buffer, 1, Compressor.bufferSize, file)
        if count == 0 {
            close()
            return nil
        }
        return Data(bytes: buffer, count: count)
    }
}

func sample() async throws {
    let start = Date.now
    let url = Bundle.main.url(forResource: "enwik8", withExtension: "zlib")!
    let bytes = stream(at: url)
    for try await page in bytes.decompressed.xmlEvents.pages {
        print(page)
    }
    print("Duration: \(Date.now.timeIntervalSince(start))")
}
