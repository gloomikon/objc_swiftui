import SwiftUI

extension View {

    func overlayWithAnchor<A, V: View>(
        value: Anchor<A>.Source,
        transform: @escaping (Anchor<A>) -> V
    ) -> some View {
        anchorPreference(
            key: AnchorKey<A>.self,
            value: value,
            transform: { anchor in anchor }
        )
        .overlayPreferenceValue(AnchorKey<A>.self) { anchor in
            transform(anchor!)
        }
    }
}
