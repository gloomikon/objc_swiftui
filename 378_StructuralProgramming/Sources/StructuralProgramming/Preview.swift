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
    let sampleBT = BookType.hardcover(title: "Gloomikon")

    var body: some View {
        VStack {
            sampleBT.view
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
