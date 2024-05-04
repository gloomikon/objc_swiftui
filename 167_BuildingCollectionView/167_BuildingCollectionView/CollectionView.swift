import SwiftUI

struct CollectionView<Elements, Content>: View where Elements: RandomAccessCollection, Content: View, Elements.Element: Identifiable {

    let data: Elements
    var layout: (Elements, [Elements.Element.ID: CGSize], CGSize) ->  [Elements.Element.ID: CGSize]
    var content: (Elements.Element) -> Content

    @State private var sizes: [Elements.Element.ID: CGSize] = [:]

    private func bodyHelper(
        containerSize: CGSize,
        offsets: [Elements.Element.ID: CGSize]
    ) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(data) { e in
                PropagateSize(content: content(e), id: e.id)
                    .offset(offsets[e.id] ?? CGSize.zero)
            }
            Color.clear
                .frame(width: containerSize.width, height: containerSize.height)
                .fixedSize()
        }
        .onPreferenceChange(CollectionViewSizeKey<Elements.Element.ID>.self) {
            sizes = $0
        }
        .background(.red)
    }

    var body: some View {
        GeometryReader { proxy in
            bodyHelper(containerSize: proxy.size, offsets: layout(data, sizes, proxy.size))
        }
    }
}

private struct CollectionViewSizeKey<ID: Hashable>: PreferenceKey {

    static var defaultValue: [ID: CGSize] { [:] }

    static func reduce(value: inout [ID: CGSize], nextValue: () -> [ID: CGSize]) {
        value.merge(nextValue()) { $1 }
    }
}

private struct PropagateSize<V: View, ID: Hashable>: View {

    let content: V
    let id: ID

    var body: some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: CollectionViewSizeKey<ID>.self,
                        value: [id: proxy.size]
                    )
                }
            }
    }
}
