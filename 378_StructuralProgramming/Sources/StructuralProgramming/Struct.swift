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

public struct Enum<Cases> {
    public let name: String
    public let cases: Cases

    public init(name: String, cases: Cases) {
        self.name = name
        self.cases = cases
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

public enum Choice<First, Second> {
    case first(First)
    case second(Second)
}

public struct Empty {

    public init() {

    }
}

public enum Nothing { }
