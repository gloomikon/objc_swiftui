import SwiftUI

// This key takes the first non-`nil` value
struct TaggedKey<Value, Tag>: PreferenceKey {

    static var defaultValue: Value? { nil }

    static func reduce(
        value: inout Value?,
        nextValue: () -> Value?
    ) {
        value = value ?? nextValue()
    }
}
