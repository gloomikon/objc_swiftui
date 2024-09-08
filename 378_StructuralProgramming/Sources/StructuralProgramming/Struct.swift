public protocol Structural {
    associatedtype Structure
    var to: Structure { get }
    static func from(_ structure: Structure) -> Self
}

public struct Struct<Properties> {
    public let name: String
    public var properties: Properties

    public init(name: String, properties: Properties) {
        self.name = name
        self.properties = properties
    }
}

public struct Property<Value> {
    public let name: String
    public var value: Value

    public init(name: String, value: Value) {
        self.name = name
        self.value = value
    }
}

public struct List<Head, Tail> {
    public var head: Head
    public var tail: Tail

    public init(head: Head, tail: Tail) {
        self.head = head
        self.tail = tail
    }
}

public struct Empty {

    public init() {

    }
}
