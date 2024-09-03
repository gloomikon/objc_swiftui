import XCTest
@testable import SwiftObservation

final class Person {

    var name: String {
        get {
            _registrar.access(self, \.name)
            return _name
        }
        set {
            _registrar.willSet(self, \.name)
            _name = newValue
        }
    }

    var age: Int {
        get {
            _registrar.access(self, \.age)
            return _age
        }
        set {
            _registrar.willSet(self, \.age)
            _age = newValue
        }
    }

    private var _name = "Tom"
    private var _age = 25

    private var _registrar = Registrar()
}

let sample = Person()

final class SwiftObservationTests: XCTestCase {

    func testAccess() throws {
        withObservationTracking {
            let _ = sample.name
            XCTAssertEqual(
                accessList,
                [
                    ObjectIdentifier(sample): Entry(keyPaths: [\Person.name])
                ]
            )
        } onChange: { }
    }

    func testObservation() throws {
        var numberOfCalls = 0

        withObservationTracking {
            _ = sample.name
        } onChange: {
            numberOfCalls += 1
        }

        XCTAssertEqual(numberOfCalls, 0)
        sample.age += 1
        XCTAssertEqual(numberOfCalls, 0)
        sample.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
        sample.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
    }
}
