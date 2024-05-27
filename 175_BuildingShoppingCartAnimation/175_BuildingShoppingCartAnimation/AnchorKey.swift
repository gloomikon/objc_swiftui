import SwiftUI

struct AnchorKey<A>: PreferenceKey {

    typealias Value = Anchor<A>?

    static var defaultValue: Value {
        nil
    }

    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = nextValue()
    }
}
