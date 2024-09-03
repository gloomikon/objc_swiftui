import Cocoa

struct Modify: AttributedStringConvertible {
    var modify: (inout Attributes) -> ()
    var contents: AttributedStringConvertible

    func attributedString(environment: Environment) -> [NSAttributedString] {
        var copy = environment
        modify(&copy.attributes)
        return contents.attributedString(environment: copy)
    }
}
