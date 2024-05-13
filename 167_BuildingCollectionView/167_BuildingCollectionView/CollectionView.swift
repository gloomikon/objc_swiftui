import SwiftUI

private extension View {
    func offset(_ point: CGPoint) -> some View {
        offset(x: point.x, y: point.y)
    }
}

struct CollectionView<Elements, Content>: View where Elements: RandomAccessCollection, Content: View, Elements.Element: Identifiable {

    typealias ID = Elements.Element.ID

    let data: Elements
    let content: (Elements.Element) -> Content
    let didMove: (Elements.Index, Elements.Index) -> Void

    @State private var sizes: [ID: CGSize] = [:]
    @State private var dragState: (id: ID, translation: CGSize, location: CGPoint)?

    private func dragOffset(for id: ID) -> CGSize {
        guard let dragState, dragState.id == id else { return .zero }
        return dragState.translation
    }

    private func bodyHelper(
        containerSize: CGSize,
        offsets: [(ID, CGSize)]
    ) -> some View {

        var insertionPoint: (id: ID, offset: CGSize)? {
            guard let dragState else { return nil }

            for offset in offsets.reversed() {
                if offset.1.width < dragState.location.x && offset.1.height < dragState.location.y {
                    return (id: offset.0, offset: offset.1)
                }
            }
            return nil
        }

        return ZStack(alignment: .topLeading) {
            ForEach(data) { e in
                PropagateSize(content: content(e), id: e.id)
                    .offset(offsets.first { e.id == $0.0 }?.1 ?? CGSize.zero)
                    .offset(dragOffset(for: e.id))
                    .gesture(
                        DragGesture()
                            .onChanged { value in dragState = (e.id, value.translation, value.location) }
                            .onEnded { _ in
                                let oldIdx = data.firstIndex { $0.id == dragState?.id }
                                let newIdx = insertionPoint.flatMap { point in
                                    data.firstIndex { $0.id == point.id }
                                }

                                if let oldIdx, let newIdx {
                                    withAnimation {
                                        didMove(oldIdx, newIdx)
                                    }
                                }

                                withAnimation { dragState = nil }
                            }
                    )
            }
            Color.clear
                .frame(width: containerSize.width, height: containerSize.height)
                .fixedSize()

            if let insertionPoint {
                Rectangle()
                    .fill(.red)
                    .frame(width: 2, height: 20)
                    .offset(insertionPoint.offset)
            }
        }
        .onPreferenceChange(CollectionViewSizeKey<ID>.self) { value in
            withAnimation {
                sizes = value
            }
        }
    }

    var body: some View {
        GeometryReader { proxy in
            bodyHelper(
                containerSize: proxy.size,
                offsets: flowLayout(for: data, sizes: sizes, containerSize: proxy.size)
            )
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
