import SwiftUI

public protocol GreatView: View {

    associatedtype GreatBody: View

    var greatBody: GreatBody { get }
}

extension GreatView {

    public var body: some View {
        TrackingView(content: self)
    }
}

struct TrackingView<Content: GreatView>: View {

    @State private var counter = 0
    let content: Content

    var body: some View {
        let _ = counter
        withObservationTracking {
            content.greatBody
        } onChange: {
            counter += 1
        }
    }
}
