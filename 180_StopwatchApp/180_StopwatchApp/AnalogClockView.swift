import SwiftUI

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }

    init(center: CGPoint, radius: CGFloat) {
        self.init(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
    }
}

struct Pointer: Shape {

    let radius: CGFloat = 4

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - radius))
            p.addEllipse(
                in: CGRect(
                    center: rect.center,
                    radius: radius
                )
            )
            p.move(to: CGPoint(x: rect.midX, y: rect.midY + radius))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height / 10))
        }
    }
}

struct AnalogClockView: View {

    var time: TimeInterval = 10
    var lapTime: TimeInterval? = 0

    @ViewBuilder
    private func tick(at index: Int) -> some View {
        Rectangle()
            .fill(.primary)
            .opacity(index.isMultiple(of: 20) ? 1 : 0.3)
            .frame(width: 2, height: index.isMultiple(of: 4) ? 15 : 7.5)
            .frame(maxHeight: .infinity, alignment: .top)
            .rotationEffect(.degrees(Double(index) / 240 * 360))
    }

    var body: some View {
        Circle()
            .fill(.clear)
            .overlay {
                ZStack {
                    ForEach(0..<240) { idx in
                        tick(at: idx)
                    }
                    if let lapTime {
                        Pointer()
                            .stroke(.blue, lineWidth: 2)
                            .rotationEffect(.degrees(lapTime * 6))
                    }
                    Pointer()
                        .stroke(.orange, lineWidth: 2)
                        .rotationEffect(.degrees(time * 6))
                    Color.clear
                }
            }
    }
}

#Preview {
    AnalogClockView()
}
