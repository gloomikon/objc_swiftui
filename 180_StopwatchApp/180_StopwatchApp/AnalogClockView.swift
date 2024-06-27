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

extension CGPoint {
    init(angle: Angle, distance: CGFloat) {
        self.init(
            x: CGFloat(cos(angle.radians)) * distance,
            y: CGFloat(sin(angle.radians)) * distance
        )
    }

    var size: CGSize {
        CGSize(width: x, height: y)
    }
}

struct Pointer: Shape {

    let radius: CGFloat = 4
    let showCircle: Bool

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - radius))

            if showCircle {
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
}

private struct Labels: View {

    let labels: [Int]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(labels.indices, id: \.self) { idx in
                    Text("\(labels[idx])")
                        .offset(
                            CGPoint(
                                angle: .degrees(360 * Double(idx) / Double(labels.count) - 90),
                                distance: proxy.size.height / 2
                            ).size)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct Ticks: View {

    let majorTicks: Int
    let subdivisions: Int
    let majorHeight: CGFloat

    private var totalTicks: Int {
        majorTicks * subdivisions
    }

    var body: some View {
        ForEach(0..<totalTicks, id: \.self) { index in
            Rectangle()
                .fill(.primary)
                .opacity(index.isMultiple(of: 5 * subdivisions) ? 1 : 0.3)
                .frame(width: 2, height: index.isMultiple(of: subdivisions) ? majorHeight : majorHeight / 2)
                .frame(maxHeight: .infinity, alignment: .top)
                .rotationEffect(.degrees(Double(index) / Double(totalTicks) * 360))
        }
    }
}

struct AnalogClockView: View {

    var time: TimeInterval = 10
    var lapTime: TimeInterval? = 3

    var miniClock: some View {
        GeometryReader { proxy in
            ZStack {
                Ticks(majorTicks: 30, subdivisions: 2, majorHeight: 10)

                Labels(labels: [30] + stride(from: 5, through: 25, by: 5))
                    .font(.caption)
                    .padding(proxy.size.height / 4)

                Pointer(showCircle: false)
                    .stroke(.orange, lineWidth: 2)
                    .rotationEffect(.degrees(time * 360 / 60 / 30))
            }
        }
    }

    var body: some View {
        GeometryReader { proxy in
            Circle()
                .fill(.clear)
                .overlay {
                    ZStack {
                        Ticks(majorTicks: 60, subdivisions: 4, majorHeight: 15)

                        Labels(labels: [60] + stride(from: 5, through: 55, by: 5))
                            .padding(proxy.size.height / 8)
                            .font(.largeTitle)

                        miniClock
                            .frame(width: proxy.size.width / 4, height: proxy.size.height / 4)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top, proxy.size.height / 5)

                        Text(time.formatted)
                            .font(.title)
                            .monospacedDigit()
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, proxy.size.height / 4)


                        if let lapTime {
                            Pointer(showCircle: false)
                                .stroke(.blue, lineWidth: 2)
                                .rotationEffect(.degrees(lapTime * 6))
                        }
                        Pointer(showCircle: true)
                            .stroke(.orange, lineWidth: 2)
                            .rotationEffect(.degrees(time * 360 / 60))
                        Color.clear
                    }
                }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    AnalogClockView()
}
