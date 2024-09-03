import Cocoa

protocol AttributedStringConvertible {

    @MainActor func attributedString(environment: Environment) -> [NSAttributedString]
}

extension String: AttributedStringConvertible {

    @MainActor func attributedString(environment: Environment) -> [NSAttributedString] {
        [NSAttributedString(string: self, attributes: environment.attributes.dict)]
    }
}

extension AttributedString: AttributedStringConvertible {

    @MainActor func attributedString(environment: Environment) -> [NSAttributedString] {
        [NSAttributedString(self)]
    }
}

extension NSAttributedString: AttributedStringConvertible {
    @MainActor func attributedString(environment: Environment) -> [NSAttributedString] {
        [self]
    }
}

extension Array: AttributedStringConvertible where Element == AttributedStringConvertible {

    @MainActor func attributedString(environment: Environment) -> [NSAttributedString] {
        flatMap { $0.attributedString(environment: environment) }
    }
}
