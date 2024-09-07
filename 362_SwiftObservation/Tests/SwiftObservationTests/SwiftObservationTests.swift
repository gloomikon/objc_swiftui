import XCTest
@testable import SwiftObservation

@SwiftObservable
final class Person {

    private var name: String = "Tom"
    private var age: Int = 25

//    var name: String {
//        get {
//            _registrar.access(self, \.name)
//            return _name
//        }
//        set {
//            _registrar.willSet(self, \.name)
//            _name = newValue
//        }
//    }
//
//    var age: Int {
//        get {
//            _registrar.access(self, \.age)
//            return _age
//        }
//        set {
//            _registrar.willSet(self, \.age)
//            _age = newValue
//        }
//    }
//
//    private var _name = "Tom"
//    private var _age = 25
}

let sample = Person()
let sample1 = Person()

final class SwiftObservationTests: XCTestCase {

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

    func testObservationMultipleObjects() throws {
        var numberOfCalls = 0

        withObservationTracking {
            _ = sample.name
            _ = sample1.name
        } onChange: {
            numberOfCalls += 1
        }

        sample.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
        sample1.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
    }
}
