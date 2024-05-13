import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct ContentView: View {

    @State var strings: [String] = (1...10).map {
        "Item \($0) " + String(repeating: "x", count: Int.random(in: 0...10))
    }

    var body: some View {
        CollectionView(data: strings) {
            Text($0)
                .padding(10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } didMove: { old , new in
            strings.move(fromOffsets: IndexSet(integer: old), toOffset: new)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
