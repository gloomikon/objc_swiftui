import SwiftUI

struct ContentView: View {

    @ObservedObject var stopwatch = Stopwatch()

    var body: some View {
        VStack {

            Text(stopwatch.total.formatted)
                .font(.largeTitle)
                .monospacedDigit()
            HStack {
                Button("Reset") {
                    stopwatch.reset()
                }
                .foregroundStyle(.gray)

                Spacer()

                if stopwatch.isRunning {
                    Button("Stop") {
                        stopwatch.stop()
                    }
                    .foregroundStyle(.red)
                } else {
                    Button("Start") {
                        stopwatch.start()
                    }
                    .foregroundStyle(.green)
                }

            }
        }
        .equalSizes()
        .buttonStyle(.circle)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
