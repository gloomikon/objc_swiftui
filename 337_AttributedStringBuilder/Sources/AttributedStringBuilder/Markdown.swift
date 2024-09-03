import Markdown
import Foundation

protocol Stylesheet {
    func strong(attributes: inout Attributes)
    func emphasis(attributes: inout Attributes)
}

extension Stylesheet {
    func strong(attributes: inout Attributes) {
        attributes.bold = true
    }

    func emphasis(attributes: inout Attributes) {
        attributes.italic = true
    }
}

private struct DefaultStylesheet: Stylesheet { }

private struct AttributedStringWalker: MarkupWalker {

    let result = NSMutableAttributedString()
    var attributes: Attributes
    let stylesheet: any Stylesheet

    func visitText(_ text: Text) -> () {
        result.append(NSAttributedString(string: text.string, attributes: attributes.dict))
    }

    mutating func visitDocument(_ document: Document) -> () {
        for child in document.children {
            if !result.string.isEmpty {
                result.append(.init(string: "\n", attributes: attributes.dict))
            }
            visit(child)
        }
    }

    mutating func visitStrong(_ strong: Strong) -> () {
        let copy = attributes
        defer {
            attributes = copy
        }
        stylesheet.strong(attributes: &attributes)
        descendInto(strong)
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) -> () {
        let copy = attributes
        defer {
            attributes = copy
        }
        stylesheet.emphasis(attributes: &attributes)
        descendInto(emphasis)
    }
}

private struct Markdown: AttributedStringConvertible {

    let content: String
    let stylesheet: any Stylesheet

    func attributedString(environment: Environment) -> [NSAttributedString] {
        let document = Document(parsing: content)
        var walker = AttributedStringWalker(attributes: environment.attributes, stylesheet: stylesheet)
        walker.visit(document)
        return [walker.result]
    }

}

extension String {

    func markdown(stylesheet: any Stylesheet = DefaultStylesheet()) -> some AttributedStringConvertible {
        Markdown(content: self, stylesheet: stylesheet)
    }
}
