import Cocoa

struct Attributes {
    var family: String = "Helvetica"
    var size: CGFloat = 14
    var traits: NSFontTraitMask = []
    var weight = 5
    var foregroundColor: NSColor = .black
    var lineHeightMultiple: CGFloat = 1.2
    var paragraphSpacing: CGFloat = 10

    var bold: Bool {
        get {
            traits.contains(.boldFontMask)
        }
        set {
            if newValue {
                traits.insert(.boldFontMask)
            } else {
                traits.remove(.boldFontMask)
            }
        }
    }

    var italic: Bool {
        get {
            traits.contains(.italicFontMask)
        }
        set {
            if newValue {
                traits.insert(.italicFontMask)
            } else {
                traits.remove(.italicFontMask)
            }
        }
    }

    var dict: [NSAttributedString.Key: Any] {
        let fm = NSFontManager.shared
        let font = fm.font(withFamily: family, traits: traits, weight: weight, size: size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.paragraphSpacing = paragraphSpacing
        return [
            .font: font,
            .foregroundColor: foregroundColor,
            .paragraphStyle: paragraphStyle
        ]
    }
}
