import SwiftUI

extension Path {
    func point(at position: CGFloat) -> CGPoint {
        assert(position >= 0 && position <= 1)
        guard position > 0 else {
            return cgPath.currentPoint
        }

        return trimmedPath(from: 0, to: position).cgPath.currentPoint
    }

    func pointAndAngle(at position: CGFloat) -> (CGPoint, Angle) {
        let p1 = point(at: position)
        let p2 = point(
            at: (position + 0.01).truncatingRemainder(dividingBy: 1)
        )
        let angle = Angle(radians: Double(atan2(p2.y - p1.y, p2.x - p1.x)))

        return (p1, angle)
    }
}
