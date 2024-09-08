struct Struct<Properties> {
    let name: String
    let properties: Properties
}

struct Property<Value> {
    let name: String
    let value: Value
}

struct List<Head, Tail> {
    let head: Head
    let tail: Tail
}

struct Empty { }
