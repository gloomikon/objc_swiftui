import Cocoa

struct Joined<Content: AttributedStringConvertible>: AttributedStringConvertible {

    var separator: AttributedStringConvertible = "\n"
    @AttributedStringBuilder var content: Content

    @MainActor func attributedString(environment: Environment) -> [NSAttributedString] {
        [single(environment: environment)]
    }

    @MainActor func single(environment: Environment) -> NSAttributedString {
        let pieces = content.attributedString(environment: environment)
        guard !pieces.isEmpty else { return NSAttributedString() }

        let separator = separator.attributedString(environment: environment)

        let result = pieces.reduce(into: NSMutableAttributedString()) { result, string in
            if !result.string.isEmpty {
                for separatorPiece in separator {
                    result.append(separatorPiece)
                }
            }
            result.append(string)
        }

        return result
    }
}

