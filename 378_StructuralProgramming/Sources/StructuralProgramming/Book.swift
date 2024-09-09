import Foundation

@Structural
struct Book {
    let title: String
    let published: Date
    let authors: String
    let updated: Bool
}

@Structural
enum BookType {

    case paperback
    case hardcover(title: String)
}
