import SwiftUI

private struct SizePreference: PreferenceKey {
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}

struct FlexibleFont: ViewModifier {

    let content: Text
    let font: (CGFloat) -> Font

    @State private var width: CGFloat?
    @State private var height: CGFloat?

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .fixedSize()
                .font( font(100 * proxy.size.width / (width ?? 1)) )
                .overlay(
                    GeometryReader { proxy in
                        Color.clear.preference(key: SizePreference.self, value: proxy.size)
                    }
                    .onPreferenceChange(SizePreference.self) { size in
                        self.height = size?.height
                    }
                )
                .background {
                    content
                        .fixedSize()
                        .font(font(100))
                        .overlay(GeometryReader { proxy in
                             Color.clear.preference(key: SizePreference.self, value: proxy.size)
                         })
                        .onPreferenceChange(SizePreference.self) { size in
                            self.width = size?.width
                        }
                        .hidden()
                }
        }
        .frame(height: height)
    }
}

extension Text {

    func flexibleFont(_ font: @escaping (CGFloat) -> Font) -> some View {
        modifier(FlexibleFont(content: self, font: font))
    }
}
