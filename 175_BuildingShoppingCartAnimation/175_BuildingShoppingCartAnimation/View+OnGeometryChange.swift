import SwiftUI

extension View {

    func onGeometryChange<Value: Equatable>(
        compute: @escaping (GeometryProxy) -> Value,
        onChange: @escaping (Value) -> Void
    ) -> some View {

        let key = TaggedKey<Value, ()>.self

        return overlay {
            GeometryReader { proxy in
                Color.clear.preference(key: key, value: compute(proxy))
            }
            .onPreferenceChange(key) { value in
                value.map { onChange($0) }
            }
            .preference(key: key, value: nil)
        }
    }
}
