import Combine
import Foundation

enum LapType {
    case regular
    case shortest
    case longest
}

struct StopwatchData {

    var absoluteStartTime: TimeInterval?
    var currentTime: TimeInterval = 0
    var lastLapTime: TimeInterval = 0
    var lastLapEndTime: TimeInterval = 0

    private var longestLapIdx: Int?
    private var shortestLapIdx: Int?

    private var _laps: [(TimeInterval, LapType)] = []

    private var currentLapTime: TimeInterval {
        totalTime - lastLapEndTime
    }

    mutating private func updateLapsInfo() {
        if let longestLapIdx {
            let longestLap = _laps[longestLapIdx].0
            if currentLapTime > longestLap {
                _laps[longestLapIdx].1 = .regular
                self.longestLapIdx = _laps.count
            }
        } else {
            longestLapIdx = _laps.count
        }

        if let shortestLapIdx {
            let shortestLap = _laps[shortestLapIdx].0
            if currentLapTime < shortestLap {
                _laps[shortestLapIdx].1 = .regular
                self.shortestLapIdx = _laps.count
            }
        } else {
            shortestLapIdx = _laps.count
        }
    }

    mutating private func updateLapsTypes() {
        if laps.count > 2 {
            if let longestLapIdx {
                _laps[longestLapIdx].1 = .longest
            }
            if let shortestLapIdx {
                _laps[shortestLapIdx].1 = .shortest
            }
        }
    }

    var laps: [(TimeInterval, LapType)] {
        guard totalTime > 0 else { return [] }
        return _laps + CollectionOfOne((currentLapTime, .regular))
    }

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

    mutating func lap() {
        updateLapsInfo()
        _laps.append((currentLapTime, .regular))
        updateLapsTypes()
        lastLapEndTime = totalTime
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

    var laps: [(TimeInterval, LapType)] {
        data.laps
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

    func lap() {
        data.lap()
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
