 import SwiftUI

struct RecordingEffect: GeometryEffect {

    @Binding var recording: [(CFTimeInterval, CGFloat)]
    let state: Bool

    private var position: CGFloat

    init(recording: Binding<[(CFTimeInterval, CGFloat)]>, state: Bool) {
        self._recording = recording
        self.state = state
        self.position = state ? 1 : 0
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        DispatchQueue.main.async {
            recording.append((CACurrentMediaTime(), position))
        }
        return ProjectionTransform()
    }

    var animatableData: CGFloat {
        get { state ? 1 : 0 }
        set { position = newValue }
    }
}

struct ContentView: View {

    @State private var flag = false
    @State private var recording: [(CFTimeInterval, CGFloat)] = []

    var body: some View {
        VStack {
            Rectangle()
                .fill(.black)
                .frame(width: 100, height: 100)
                .offset(y: flag ? 200 : 0)
                .modifier(
                    RecordingEffect(
                        recording: $recording,
                        state: flag
                    )
                )
                .animation(
                    .spring(),
                    value: flag
                )
            Plot(data: recording)
                .stroke(.red, lineWidth: 2)
                .frame(width: 300, height: 300)
                .border(.gray)
                .offset(y: 220)
            Spacer()
            Toggle(isOn: $flag, label: {
                Text("Flag")
            })
            .padding()
        }
    }
}

struct Plot: Shape {

    let data: [(CGFloat, CGFloat)]

    init(data: [(CFTimeInterval, CGFloat)]) {
        guard let last = data.last else {
            self.data = []
            return
        }
        let maxX = last.0
        let slice = data.drop { $0.0 < maxX - 3 }
        guard let minX = slice.first?.0 else {
            self.data = []
            return
        }
        self.data = slice.map { interval, data in
            ((interval - minX) / (maxX - minX), data)
        }
    }

    func path(in rect: CGRect) -> Path {
        guard !data.isEmpty else { return Path() }

        let points = data.map {
            CGPoint(x: $0.0 * rect.width, y: $0.1 * rect.height)
        }

        return Path { p in
            p.move(to: points[0])
            p.addLines(points)
        }
    }
}

#Preview {
    ContentView()
}
