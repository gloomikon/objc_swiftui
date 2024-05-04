import UIKit

struct FlowLayout {

    private let containerSize: CGSize
    private let spacing: UIOffset

    init(
        containerSize: CGSize,
        spacing: UIOffset = UIOffset(horizontal: 10, vertical: 10)
    ) {
        self.spacing = spacing
        self.containerSize = containerSize
    }

    var currentX = 0 as CGFloat
    var currentY = 0 as CGFloat
    var lineHeight = 0 as CGFloat

    mutating func add(element size: CGSize) -> CGRect {
        if currentX + size.width > containerSize.width {
            currentX = 0
            currentY += lineHeight + spacing.vertical
            lineHeight = 0
        }

        defer {
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing.horizontal
        }

        return CGRect(origin: CGPoint(x: currentX, y: currentY), size: size)
    }

    var size: CGSize {
        CGSize(width: containerSize.width, height: currentY + lineHeight)
    }
}

func flowLayout<Elements>(
    for elements: Elements,
    sizes: [Elements.Element.ID: CGSize],
    containerSize: CGSize
) -> [Elements.Element.ID: CGSize] where Elements: RandomAccessCollection, Elements.Element: Identifiable {
    var state = FlowLayout(containerSize: containerSize)
    var result: [Elements.Element.ID: CGSize] = [:]

    for element in elements {
        let rect = state.add(element: sizes[element.id] ?? .zero)
        result[element.id] = CGSize(width: rect.origin.x, height: rect.origin.y)
    }

    return result
}
