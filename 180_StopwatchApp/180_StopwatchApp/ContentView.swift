import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Button("Reset") {
                print("reset")
            }
            .foregroundStyle(.red)
            Button("Start") {
                print("start")
            }
            .foregroundStyle(.green)
        }
        .equalSizes()
        .buttonStyle(.circle)
        .padding()
    }
}

#Preview {
    ContentView()
}
