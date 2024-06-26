import SwiftUI

struct ContentView: View {

    @ObservedObject var stopwatch = Stopwatch()

    var body: some View {
        VStack {

//            Text(stopwatch.total.formatted)
//                .font(.largeTitle)
//                .monospacedDigit()

            AnalogClockView(
                time: stopwatch.total,
                lapTime: stopwatch.laps.last?.0
            )

            HStack {
                EitherView(if: stopwatch.isRunning) {
                    Button("Lap") {
                        stopwatch.lap()
                    }
                } else: {
                    Button("Reset") {
                        stopwatch.reset()
                    }
                }
                .foregroundStyle(.gray)

                Spacer()

                EitherView(if: stopwatch.isRunning) {
                    Button("Stop") {
                        stopwatch.stop()
                    }
                    .foregroundStyle(.red)
                } else: {
                    Button("Start") {
                        stopwatch.start()
                    }
                    .foregroundStyle(.green)
                }
            }

            List(stopwatch.laps.enumerated().reversed(), id: \.offset) { idx, lap in
                HStack {
                    Text("Lap \(idx + 1)")
                    Spacer()
                    Text(lap.0.formatted)
                        .font(.body)
                        .monospacedDigit()
                }
                .foregroundStyle(lap.1.foregroundColor)
            }
            .listStyle(.plain)
        }
        .equalSizes()
        .buttonStyle(.circle)
        .padding(.horizontal)
    }
}

private extension LapType {
    var foregroundColor: Color {
        switch self {
        case .regular:
            Color(.label)
        case .shortest:
                .green
        case .longest:
                .red
        }
    }
}

#Preview {
    ContentView()
}
