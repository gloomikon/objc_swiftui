import Foundation

private final class Box<A> {
    let unbox: A

    init(_ unbox: A) {
        self.unbox = unbox
    }
}

struct MyData {

    fileprivate var data = Box(NSMutableData())

    var dataForWriting: NSMutableData {
        mutating get {
            if isKnownUniquelyReferenced(&data) {
                return data.unbox
            } else {
                data = Box(data.unbox.mutableCopy() as! NSMutableData)
                return data.unbox
            }
        }
    }

    mutating func append(bytes: [UInt8]) {
        dataForWriting.append(bytes, length: bytes.count)
    }
}

extension MyData: CustomDebugStringConvertible {
    var debugDescription: String {
        String(describing: data)
    }
}

func test() {
    var data = MyData()
    var copy = data
    data.append(bytes: [0x12, 0x34, 0x56, 0x78])
}
