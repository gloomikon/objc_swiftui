import Foundation

typealias SQLValue = String

enum Fragment {
    case literal(String)
    case value(SQLValue)
}

struct QueryPart {
    var parts: [Fragment]
}

struct Query {
    let query: QueryPart

    init(_ part: QueryPart) {
        self.query = part
    }
}

extension QueryPart: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        parts = [.literal(value)]
    }
}

extension QueryPart: ExpressibleByStringInterpolation {
    typealias StringInterpolation = QueryPart

    init(stringInterpolation: QueryPart) {
        parts = stringInterpolation.parts
    }
}

extension QueryPart: StringInterpolationProtocol {
    init(literalCapacity: Int, interpolationCount: Int) {
        parts = []
    }

    mutating func appendLiteral(_ literal: String) {
        parts.append(.literal(literal))
    }

    mutating func appendInterpolation(param value: SQLValue) {
        parts.append(.value(value))
    }

    mutating func appendInterpolation(raw value: String) {
        parts.append(.literal(value))
    }
}

extension QueryPart {
    mutating func append(_ other: QueryPart) {
        parts.append(contentsOf: other.parts)
    }

    func appending(_ other: QueryPart) -> QueryPart {
        var copy = self
        copy.append(other)
        return copy
    }
}

extension Query {
    func appending(_ other: QueryPart) -> Query {
        return Query(query.appending(other))
    }
}

extension QueryPart {
    var sql: String {
        var counter = 1
        return parts.reduce(into: "", { str, part in
            switch part {
            case let .literal(s):
                str.append(s)
            case .value:
                str.append("$\(counter)")
                counter += 1
            }
        })
    }

    var values: [SQLValue] {
        return parts.compactMap { part in
            guard case let .value(v) = part else { return nil }
            return v
        }
    }
}

let id = "1234"
let email = "mail@objc.io"
let tableName = "users"
let sample = Query("SELECT * FROM \(raw: tableName) WHERE id=\(param: id) AND email=\(param: email)")

let city = "Berlin"
let sample2 = sample.appending(" AND city=\(param: city)")

assert(sample.query.sql == "SELECT * FROM users WHERE id=$1 AND email=$2")
assert(sample.query.values == [id, email])
print(sample2.query.sql)
print(sample2.query.values)
