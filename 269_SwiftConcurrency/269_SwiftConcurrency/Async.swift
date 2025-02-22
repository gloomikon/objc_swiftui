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

func sample() async throws {
    let start = Date.now
    let url = Bundle.main.url(forResource: "enwik8", withExtension: "zlib")!

    var counter = 0

    let fileHandle = try FileHandle(forReadingFrom: url)
    for try await event in fileHandle.bytes.chunked.decompressed.xmlEvents {
        guard case let .didStart(element) = event else { continue }
        print(element)
        counter += 1
    }

    print(counter)
    print("Duration: \(Date.now.timeIntervalSince(start))")
}
