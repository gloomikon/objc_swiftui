import Foundation

struct Book {
    let title: String
    let published: Date
}

extension Book {
    typealias Structure = Struct<List<Property<String>, List<Property<Date>, Empty>>>

    var to: Structure {
        .init(
            name: "Book",
            properties: .init(
                head: .init(name: "title", value: title),
                tail: .init(
                    head: .init(name: "published", value: published),
                    tail: .init()
                )
            )
        )
    }

    static func from(_ s: Structure) -> Self {
        .init(
            title: s.properties.head.value,
            published: s.properties.tail.head.value
        )
     }
}

#if DEBUG

import SwiftUI

struct ContentView: View {
    var book = Book(title: "Thinking in SwiftUI", published: .now)

    var body: some View {
        book.to.view
            .padding()
    }
}

#Preview {
    ContentView()
}

#endif
