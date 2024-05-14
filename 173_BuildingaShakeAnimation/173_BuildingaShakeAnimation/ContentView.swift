import SwiftUI

struct ContentView: View {

    @State private var attempts = 0

    var body: some View {

        VStack {

            Button {
                attempts += 1
            } label: {
                Text("Shake")
            }

            Rectangle()
                .fill(.purple)
                .frame(width: 200, height: 200)
                .modifier(ShakeEffect(shakes: attempts * 2))
                .animation(.linear, value: attempts)
        }
    }
}

struct ShakeEffect: GeometryEffect {

    init(shakes: Int) {
        self.position = CGFloat(shakes)
    }

    var position: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: -30 * sin(position * 2 * .pi),
            y: 0
        ))
    }

    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

#Preview {
    ContentView()
}
