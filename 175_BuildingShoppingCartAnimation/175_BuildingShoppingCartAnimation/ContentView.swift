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

struct AnchorKey: PreferenceKey {

    static var defaultValue: Anchor<CGPoint>? {
        nil
    }

    static func reduce(
        value: inout Anchor<CGPoint>?,
        nextValue: () -> Anchor<CGPoint>?
    ) {
        value = nextValue()
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
                        .anchorPreference(
                            key: AnchorKey.self,
                            value: .topLeading,
                            transform: { anchor in anchor }
                        )
                        .overlayPreferenceValue(AnchorKey.self) { anchor in
                            Button {
                                withAnimation {
                                    cartItems.append((idx: idx, anchor: anchor!))
                                }
                            } label: { Color.clear }
                        }
                }
            }

            Spacer()
            RoundedRectangle(cornerRadius: 5)
                .fill(.gray)
                .frame(width: 100, height: 100)
                .overlay {
                    Text("\(cartItems.count)")
                }
                .background {
                    GeometryReader { proxy in
                        ZStack {
                            ForEach(Array(cartItems.enumerated()), id: \.offset) { _, item in
                                ShoppingItem(index: item.idx)
                                    .transition(.offset(
                                        x: proxy[item.anchor].x,
                                        y: proxy[item.anchor].y
                                    ))
                            }
                        }
                    }
                    .frame(width: 50, height: 50)
                }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
