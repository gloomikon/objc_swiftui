import SwiftUI

fileprivate struct SizeKey: PreferenceKey {
    static let defaultValue: [CGSize] = []
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}

fileprivate struct EqualSize: ViewModifier {
    @Environment(\.size) private var size

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { proxy in
                Color.clear.preference(key: SizeKey.self, value: [proxy.size])
            })
            .frame(width: size?.width, height: size?.width)
    }
}

extension View {
    func equalSize() -> some View {
        modifier(EqualSize())
    }
}

fileprivate struct SizeEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGSize? = nil
}

fileprivate extension EnvironmentValues {
    var size: CGSize? {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
}


fileprivate struct EqualSizes: ViewModifier {
    @State var width: CGFloat?
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(SizeKey.self, perform: { sizes in
                self.width = sizes.map { $0.width }.max()
            })
            .environment(\.size, width.map { CGSize(width: $0, height: $0) })
    }
}

extension View {
    func equalSizes() -> some View {
        modifier(EqualSizes())
    }
}
