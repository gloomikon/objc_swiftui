import Foundation

final class Atomic<Value> {

    private var _value: Value

    private let queue = DispatchQueue(label: "atomic_sync_queue")

    init(_ value: Value) {
        self._value = value
    }

    var value: Value {
        queue.sync { _value }
    }

    func atomically(_ transform: (inout Value) -> ()) {
        queue.sync {
            transform(&_value)
        }
    }
}

extension Array {

    func concurrentMap<B>(_ transform: @escaping (Element) -> B) -> [B] {
        let result = Atomic<Array<B?>>(.init(repeating: nil, count: count))
        DispatchQueue.concurrentPerform(iterations: count) { idx in
            let e = self[idx]
            let r = transform(e)
            result.atomically {
                $0[idx] = r
            }
        }
        return result.value.map { $0! }
    }
}
