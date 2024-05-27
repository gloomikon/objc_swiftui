import SwiftUI

struct AppearFrom: ViewModifier {

    @State private var didAppear = false

    let anchor: Anchor<CGPoint>

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .offset(didAppear ? .zero : CGSize(width: proxy[anchor].x, height: proxy[anchor].y))
                .onAppear {
                    didAppear = true
                }
                .animation(.default, value: didAppear)
        }
    }
}

extension View {
    func appearFrom(anchor: Anchor<CGPoint>) -> some View {
        modifier(AppearFrom(anchor: anchor))
    }
}
