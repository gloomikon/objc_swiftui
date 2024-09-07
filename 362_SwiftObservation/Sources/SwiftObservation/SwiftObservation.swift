import Foundation

struct Entry {
    var keyPaths: Set<AnyKeyPath> = []
    var registrar: Registrar
}

final class Registrar {

    typealias Observer = () -> Void

    private struct Observation: Hashable {

        let id: UUID
        let observer: Observer

        init(id: UUID = UUID(), observer: @escaping Observer) {
            self.id = id
            self.observer = observer
        }

        static func == (lhs: Registrar.Observation, rhs: Registrar.Observation) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    private var observations: [AnyKeyPath: Set<Observation>] = [:]

    func access<Source: AnyObject, Target>(
        _ object: Source,
        _ keyPath: KeyPath<Source, Target>
    ) {
        accessList[ObjectIdentifier(object), default: Entry(registrar: self)].keyPaths.insert(keyPath)
    }

    func willSet<Source: AnyObject, Target>(
        _ object: Source,
        _ keyPath: KeyPath<Source, Target>
    ) {
        guard let observations = observations[keyPath] else { return }
        for observation in observations {
            observation.observer()
        }
    }

    func addObserver(_ observer: @escaping Observer, for keyPaths: Set<AnyKeyPath>) -> UUID {
        let id = UUID()

        for keyPath in keyPaths {
            observations[keyPath, default: []].insert(Observation(id: id, observer: observer))
        }

        return id
    }

    func removeObserver(with id: UUID) {
        for key in observations.keys {
            observations[key]?.remove(Observation(id: id, observer: { }))
            if observations[key]?.isEmpty == true {
                observations[key] = nil
            }
        }
    }
}

var accessList: [ObjectIdentifier: Entry] = [:]

func withObservationTracking<T>(
    _ apply: () -> T,
    onChange: @escaping () -> Void
) -> T {

    let result = apply()

    var removeObservers: [() -> Void] = []
    let fire = {
        onChange()
        for removeObserver in removeObservers {
            removeObserver()
        }
    }

    for entry in accessList.values {
        let id = entry.registrar.addObserver(fire, for: entry.keyPaths)
        removeObservers.append {
            entry.registrar.removeObserver(with: id)
        }
    }

    return result
}
