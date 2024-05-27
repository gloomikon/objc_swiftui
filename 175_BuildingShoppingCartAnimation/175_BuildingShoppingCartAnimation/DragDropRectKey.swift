import SwiftUI

struct DragRectKey: PreferenceKey {

    typealias Value = CGRect?

    static var defaultValue: Value { nil }

    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = value ?? nextValue()
    }
}

struct DropRectKey: PreferenceKey {

    typealias Value = CGRect?

    static var defaultValue: Value { nil }

    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = value ?? nextValue()
    }
}
