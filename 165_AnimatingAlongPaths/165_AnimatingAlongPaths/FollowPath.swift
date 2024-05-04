import SwiftUI

struct FollowPath<P: Shape>: GeometryEffect {

    let pathShape: P
    var offset: CGFloat // 0...1

    func effectValue(size: CGSize) -> ProjectionTransform {
        let path = pathShape.path(in: CGRect(origin: .zero, size: size))
        let (point, angle) = path.pointAndAngle(at: offset)

        let affineTransform = CGAffineTransform(translationX: point.x, y: point.y)
            .rotated(by: CGFloat(angle.radians) + .pi / 2)

        return ProjectionTransform(affineTransform)
    }

    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
}
