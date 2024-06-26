import SwiftUI

struct EitherView<Left: View, Right: View>: View {

    let condition: Bool
    let left: Left
    let right: Right

    init(
        if condition: Bool,
        @ViewBuilder left: () -> Left,
        @ViewBuilder else right: () -> Right
    ) {
        self.condition = condition
        self.left = left()
        self.right = right()
    }

    var body: some View {
        ZStack {
            left
                .opacity(condition ? 1 : 0)
            right
                .opacity(condition ? 0 : 1)
        }
    }
}
