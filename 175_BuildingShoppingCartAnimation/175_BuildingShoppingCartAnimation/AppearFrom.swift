import SwiftUI

struct AppearFrom: ViewModifier {

    @State private var contentFrame: CGRect?
    @State private var didAppear = false

    let anchor: Anchor<CGPoint>
    private let key = TaggedKey<CGRect, ()>.self

    func body(content: Content) -> some View {
        return GeometryReader { proxy in
            content
                .overlay {
                    GeometryReader { proxy in
                        Color.clear.preference(key: key, value: proxy.frame(in: .global))
                    }
                }
                .offset(didAppear ? .zero : CGSize(width: proxy[anchor].x, height: proxy[anchor].y))
                .onAppear {
                    didAppear = true
                }
                .animation(.default, value: didAppear)
        }
        .frame(width: contentFrame?.width, height: contentFrame?.height)
        .onPreferenceChange(key) { value in
            contentFrame = value
        }
    }
}

extension View {
    func appearFrom(anchor: Anchor<CGPoint>) -> some View {
        modifier(AppearFrom(anchor: anchor))
    }
}
