import SwiftUI

struct OnPath<P: Shape, S: Shape>: Shape {

    var shape: S
    let pathShape: P
    var offset: CGFloat // 0...1

    func path(in rect: CGRect) -> Path {
        let path = pathShape.path(in: rect)
        let (point, angle) = path.pointAndAngle(at: offset)
        let shapePath = shape.path(in: rect)
        let size = shapePath.boundingRect.size
        let head = shapePath
            .offsetBy(
                dx: -size.width / 2,
                dy: -size.height / 2
            )
            .applying(CGAffineTransform(rotationAngle: CGFloat(angle.radians) + .pi / 2))
            .offsetBy(
                dx: point.x,
                dy: point.y
            )

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

        result.addPath(head)
        return result
    }

    var animatableData: AnimatablePair<CGFloat, S.AnimatableData> {
        get {
            AnimatablePair(offset, shape.animatableData)
        }
        set {
            offset = newValue.first
            shape.animatableData = newValue.second
        }
    }
}
