import Foundation

@Structural
struct Book {
    let title: String
    let published: Date
    let authors: String
    let updated: Bool
}

#if DEBUG

import SwiftUI

struct ContentView: View {
    var book = Book(
        title: "Thinking in SwiftUI",
        published: .now,
        authors: "gloomikon",
        updated: true
    )

    var body: some View {
        book.to.view
            .padding()
    }
}

#Preview {
    ContentView()
}

#endif
