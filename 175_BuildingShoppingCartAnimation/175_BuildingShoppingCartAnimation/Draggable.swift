import SwiftUI

struct Draggable<Content: View>: View {

    @GestureState private var state: DragGesture.Value? = nil

    let content: Content
    let snapBack: Bool
    let onTapped: (Anchor<CGPoint>) -> Void
    let onDragged: (CGRect) -> Void
    let onEnded: (Anchor<CGPoint>) -> Void

    var body: some View {
        let translation = state?.translation ?? .zero
        return ZStack {
            content
                .overlayWithAnchor(value: .point(CGPoint(x: translation.width, y: translation.height))) { anchor in
                    Color.white.opacity(0.001)
                        .onTapGesture { onTapped(anchor) }
                        .highPriorityGesture(
                            DragGesture()
                                .updating($state) { value, state, _ in
                                    state = value
                                }
                                .onEnded { _ in onEnded(anchor) }
                        )
                }

            if let state {
                content
                    .onGeometryChange {
                        proxy in proxy.frame(in: .global)
                    } onChange: { value in
                        onDragged(value)
                    }
                    .offset(state.translation)
                    .transition(.offset(snapBack ? -state.translation : .zero))
                    .animation(.default)
            }
        }
    }
}

extension View {

    func draggable(
        snapBack: Bool,
        onTapped: @escaping (Anchor<CGPoint>) -> Void,
        onDragged: @escaping (CGRect) -> Void,
        onEnded: @escaping (Anchor<CGPoint>) -> Void
    ) -> some View {
        Draggable(
            content: self,
            snapBack: snapBack,
            onTapped: onTapped,
            onDragged: onDragged,
            onEnded: onEnded
        )
    }
}
