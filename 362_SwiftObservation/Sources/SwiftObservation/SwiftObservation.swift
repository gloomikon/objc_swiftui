struct Entry: Equatable {
    var keyPaths: Set<AnyKeyPath> = []
}

final class Registrar {

    typealias Observer = () -> Void
    var observers: [AnyKeyPath: [Observer]] = [:]

    func access<Source: AnyObject, Target>(
        _ object: Source,
        _ keyPath: KeyPath<Source, Target>
    ) {
        accessList[ObjectIdentifier(object), default: Entry()].keyPaths.insert(keyPath)
    }

    func willSet<Source: AnyObject, Target>(
        _ object: Source,
        _ keyPath: KeyPath<Source, Target>
    ) {
        guard let observers = observers[keyPath] else { return }
        for observer in observers {
            observer()
        }
    }
}

var accessList: [ObjectIdentifier: Entry] = [:]

func withObservationTracking<T>(
    _ apply: () -> T,
    onChange: @escaping () -> Void
) -> T {
    let result = apply()
    return result
}
