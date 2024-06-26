import Combine
import Foundation

struct StopwatchData {

    var absoluteStartTime: TimeInterval?
    var currentTime: TimeInterval = 0
    var lastLapTime: TimeInterval = 0

    var totalTime: TimeInterval {
        guard let absoluteStartTime else { 
            return lastLapTime
        }
        return lastLapTime + currentTime - absoluteStartTime
    }

    mutating func start(at time: TimeInterval) {
        absoluteStartTime = time
        currentTime = time
    }

    mutating func stop() {
        lastLapTime = totalTime
        absoluteStartTime = nil
    }
}

class Stopwatch: ObservableObject {

    @Published private var data = StopwatchData()

    private var timer: Timer?

    var total: TimeInterval {
        data.totalTime
    }

    var isRunning: Bool {
        data.absoluteStartTime != nil
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] timer in
            data.currentTime = Date.now.timeIntervalSinceReferenceDate
        })
        data.start(at: Date.now.timeIntervalSinceReferenceDate)
    }

    func reset() {
        stop()
        data = StopwatchData()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        data.stop()
    }

    deinit {
        stop()
    }
}
