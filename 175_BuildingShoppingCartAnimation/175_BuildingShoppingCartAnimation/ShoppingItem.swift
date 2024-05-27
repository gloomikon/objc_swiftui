import SwiftUI

let colors: [Color] = [
    .red,
    .yellow,
    .green,
    .blue,
    .purple
]

let images: [String] = [
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
