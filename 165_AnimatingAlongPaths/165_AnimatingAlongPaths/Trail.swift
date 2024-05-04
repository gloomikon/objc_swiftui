import SwiftUI

struct Trail<P: Shape>: Shape {

    let pathShape: P
    var offset: CGFloat // 0...1

    func path(in rect: CGRect) -> Path {
        let path = pathShape.path(in: rect)

        var result = Path()
        let trailLength = 0.2 as CGFloat

        let trimFrom = offset - trailLength
        let trailStyle = StrokeStyle(lineWidth: 3)

        if trimFrom < .zero {
            result.addPath(
                path
                    .trimmedPath(from: trimFrom + 1, to: 1)
            )
        }

        result.addPath(
            path
                .trimmedPath(from: max(0, trimFrom), to: offset)
        )

        result = result.strokedPath(trailStyle)

        return result
    }

    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
}
