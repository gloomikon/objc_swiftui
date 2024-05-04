import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct ContentView: View {

    let strings: [String] = (1...10).map {
        "Item \($0) " + String(repeating: "x", count: Int.random(in: 0...10))
    }

    @State private var dividerWidth: CGFloat = 100

    var body: some View {
        VStack {
            HStack {
                Rectangle().fill(.red)
                    .frame(width: dividerWidth)

                CollectionView(data: strings, layout: flowLayout) {
                    Text($0)
                        .padding(10)
                        .background(.gray)
                }
            }

            Slider(value: $dividerWidth, in: 0...500)
        }
        .clipped()
    }
}

#Preview {
    ContentView()
}
