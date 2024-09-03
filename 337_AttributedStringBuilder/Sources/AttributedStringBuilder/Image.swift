import Cocoa

extension NSImage: AttributedStringConvertible {

    func attributedString(environment: Environment) -> [NSAttributedString] {
        let attachment = NSTextAttachment()
        attachment.image = self
        return [
            NSAttributedString(attachment: attachment)
        ]
    }
}
