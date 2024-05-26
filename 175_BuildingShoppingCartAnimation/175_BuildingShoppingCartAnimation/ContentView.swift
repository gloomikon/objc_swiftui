import SwiftUI

private let colors: [Color] = [
    .red,
    .yellow,
    .green,
    .blue,
    .purple
]

private let images: [String] = [
    "airplane",
    "lightbulb.circle",
    "clock",
    "book.circle",
    "wand.and.rays"
]

struct ShoppingItem: View {

    let index: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(colors[index])
            .frame(width: 50, height: 50)
            .overlay {
                Image(systemName: images[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .padding(12)
            }
    }
}

struct AnchorKey<A>: PreferenceKey {

    typealias Value = Anchor<A>?

    static var defaultValue: Value {
        nil
    }

    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = nextValue()
    }
}

struct AppearFrom: ViewModifier {

    @State private var didAppear = false

    let anchor: Anchor<CGPoint>

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .offset(didAppear ? .zero : CGSize(width: proxy[anchor].x, height: proxy[anchor].y))
                .onAppear {
                    didAppear = true
                }
                .animation(.default, value: didAppear)
        }
    }
}

extension View {

    func overlayWithAnchor<A, V: View>(
        value: Anchor<A>.Source,
        transform: @escaping (Anchor<A>) -> V
    ) -> some View {
        anchorPreference(
            key: AnchorKey<A>.self,
            value: value,
            transform: { anchor in anchor }
        )
        .overlayPreferenceValue(AnchorKey<A>.self) { anchor in
            transform(anchor!)
        }
    }

    func appearFrom(anchor: Anchor<CGPoint>) -> some View {
        modifier(AppearFrom(anchor: anchor))
    }
}

struct ContentView: View {

    @State private var cartItems: [(idx: Int, anchor: Anchor<CGPoint>)] = []

    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(0..<colors.count, id: \.self) { idx in
                    ShoppingItem(index: idx)
                        .overlayWithAnchor(value: .topLeading) { anchor in
                            Button {
                                cartItems.append((idx: idx, anchor: anchor))
                            } label: { Color.clear }
                        }
                }
            }

            Spacer()


            HStack {
                ForEach(Array(cartItems.enumerated()), id: \.offset) { idx, item in
                    ShoppingItem(index: item.idx)
                        .appearFrom(anchor: item.anchor)
                    .frame(width: 50, height: 50)
                }
            }
            .animation(.default, value: cartItems.count)
            .frame(height: 50)

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
