import SwiftUI

struct ContentView: View {

    @State private var cartItems: [(idx: Int, anchor: Anchor<CGPoint>)] = []
    @State private var dragRect: CGRect?
    @State private var dropRect: CGRect?

    private var isInDropZone: Bool {
        guard let dragRect, let dropRect else { return false }
        return dragRect.intersects(dropRect)
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(0..<colors.count, id: \.self) { idx in
                    ShoppingItem(index: idx)
                        .draggable(snapBack: !isInDropZone) { anchor in
                            cartItems.append((idx: idx, anchor: anchor))
                        } onDragged: { rect in
                            dragRect = rect
                        } onEnded: { anchor in
                            guard isInDropZone else { return }
                            cartItems.append((idx: idx, anchor: anchor))
                        }
                }
            }
            .zIndex(1)

            Spacer()

            HStack {
                ForEach(Array(cartItems.enumerated()), id: \.offset) { idx, item in
                    ShoppingItem(index: item.idx)
                        .appearFrom(anchor: item.anchor)
                        .transition(.identity)
                }
            }
            .animation(.default, value: cartItems.count)
            .frame(height: 50)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color(white: isInDropZone ? 0.7 : 0.5))
            .onGeometryChange { 
                proxy in proxy.frame(in: .global)
            } onChange: { value in
                dropRect = value
            }

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
