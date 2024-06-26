import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label.modifier(ButtonCircle(isPressed: configuration.isPressed))
    }
}

extension ButtonStyle where Self == CircleButtonStyle {
    static var circle: CircleButtonStyle {
        CircleButtonStyle()
    }
}

struct ButtonCircle: ViewModifier {
    let isPressed: Bool

    func body(content: Content) -> some View {
        let background = Circle()
            .fill()
            .padding(4)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
            }
            .opacity(isPressed ? 0.75 : 1)

        let foreground = content
            .fixedSize()
            .padding(15)
            .equalSize()
            .foregroundColor(.white)
        return foreground
            .background(background)
    }
}
