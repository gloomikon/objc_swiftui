import SwiftUI

extension View {

    func overlayWithAnchor<A, V: View>(
        value: Anchor<A>.Source,
        transform: @escaping (Anchor<A>) -> V
    ) -> some View {

        let key = TaggedKey<Anchor<A>, ()>.self

        return anchorPreference(
            key: key,
            value: value,
            transform: { anchor in anchor }
        )
        .overlayPreferenceValue(key) { anchor in
            transform(anchor!)
        }
        .preference(key: key, value: nil)
    }
}
