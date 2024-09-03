import Cocoa

extension AttributedStringConvertible {
    func joined(separator: AttributedStringConvertible = "\n") -> some AttributedStringConvertible {
        Joined(separator: separator) {
            self
        }
    }

    @MainActor func run(environment: Environment) -> NSAttributedString {
        Joined(separator: "") {
            self
        }
        .single(environment: environment)
    }

    func bold() -> some AttributedStringConvertible {
        Modify(modify: { $0.bold = true }, contents: self)
    }

    func foregroundColor(_ color: NSColor) -> some AttributedStringConvertible {
        Modify(modify: { $0.foregroundColor = color }, contents: self)
    }
}
