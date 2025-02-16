import Foundation

struct User: Decodable {
    let name: String
    let createdAt: Date
    let updatedAt: Date
    let githubId: Int

    enum CodingKeys: String, CodingKey {
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case githubId = "github_id"
    }
}

protocol Connection {
    func execute(query: String, values: [Any])
}

extension User {
//    func insert(into connection: Connection) {
//        connection.execute(
//            query: "INSERT INTO users (name, created_at, updated_at, github_id",
//            values: [name, createdAt, updatedAt, githubId]
//        )
//    }

    func insert(into connection: Connection) {
        connection.execute(
            query: "INSERT INTO users (name, created_at, updated_at, github_id",
            values: [name, createdAt, updatedAt, githubId]
        )
    }
}

// Mirror can be used if we already have a value

func fieldsAndValues(_ value: Any) -> [(String, Any)] {
    let mirror = Mirror(reflecting: value)
    return mirror.children.map { child in
        // no name if we reflect on tuple
        (child.label!, child.value)
    }
}

let gloomikon = User(name: "gloomikon", createdAt: .now, updatedAt: .now, githubId: 1301)

print(fieldsAndValues(gloomikon))


class FieldsDecoder: Decoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]

    var keys: [String] = []

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer(KDC(decoder: self))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SVDC(decoder: self)
    }

    private struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {

        let decoder: FieldsDecoder

        var codingPath: [CodingKey] = []
        var allKeys: [Key] = []

        func contains(_ key: Key) -> Bool {
            true
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            decoder.keys.append(key.stringValue)
            return true
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            decoder.keys.append(key.stringValue)
            return false
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            decoder.keys.append(key.stringValue)
            return ""
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            decoder.keys.append(key.stringValue)
            return 0
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            decoder.keys.append(key.stringValue)
            return 0
        }


        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            decoder.keys.append(key.stringValue)
            return try T(from: decoder)
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
            fatalError()
        }

        func superDecoder() throws -> any Decoder {
            fatalError()
        }

        func superDecoder(forKey key: Key) throws -> any Decoder {
            fatalError()
        }
    }

    private struct SVDC: SingleValueDecodingContainer {

        let decoder: FieldsDecoder

        var codingPath: [any CodingKey] = []

        func decodeNil() -> Bool {
            true
        }

        func decode(_ type: Bool.Type) throws -> Bool {
            false
        }

        func decode(_ type: String.Type) throws -> String {
            ""
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            0
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
            0
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            0
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            0
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            0
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            0
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            0
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            0
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            0
        }

        func decode(_ type: Int.Type) throws -> Int {
            0
        }

        func decode(_ type: Float.Type) throws -> Float {
            0
        }

        func decode(_ type: Double.Type) throws -> Double {
            0
        }

        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            try T(from: decoder)
        }
    }
}

let decoder = FieldsDecoder()

let user = try User(from: decoder)
print(decoder.keys)
