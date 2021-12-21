import XCTest
import Blitzlichtgewitter

final class IntersectionTests : XCTestCase {

    func testAnIntersectionEncapsulatedTAndObject() {
        let s: Sphere = .unit
        let i = Intersection(t: 3.5, object: s)
        XCTAssertEqual(i.t, 3.5)
        XCTAssertEqual(i.object, s)
    }

}
