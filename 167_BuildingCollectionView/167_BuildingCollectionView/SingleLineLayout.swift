import UIKit

func singleLineLayout<Elements>(
    for elements: Elements,
    sizes: [Elements.Element.ID: CGSize],
    containerSize: CGSize
) -> [Elements.Element.ID: CGSize] where Elements: RandomAccessCollection, Elements.Element: Identifiable {
    var result: [Elements.Element.ID: CGSize] = [:]

    var offset = CGSize.zero

    for element in elements {
        result[element.id] = offset

        let size = sizes[element.id] ?? CGSize.zero
        offset.width += size.width + 10
    }

    return result
}
