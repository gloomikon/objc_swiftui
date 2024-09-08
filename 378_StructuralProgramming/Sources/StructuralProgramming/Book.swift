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

var initial = Book(
    title: "Thinking in SwiftUI",
    published: .now,
    authors: "gloomikon",
    updated: true
)

struct ContentView: View {

    @State private var book = initial

    var body: some View {
        VStack {
            book.view
            Form {
                book.edit($book)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

#endif
