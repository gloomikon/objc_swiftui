import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Shape following path") {
                    ShapeFollowingPathExampleView()
                }

                NavigationLink("View following path") {
                    ViewFollowingPathExampleView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
