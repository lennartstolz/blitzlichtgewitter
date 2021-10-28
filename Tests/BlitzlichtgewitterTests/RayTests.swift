import XCTest
import Blitzlichtgewitter

final class RayTests : XCTestCase {

    func testCreatingAndQueryingARay() {
        let r = Ray(origin: point(1, 2, 3), direction: vector(4, 5, 6))
        XCTAssertEqual(r.origin, point(1, 2, 3))
        XCTAssertEqual(r.direction, vector(4, 5, 6))
    }

    func testComputingAPointFromADistance() {
        let r = Ray(origin: point(2, 3, 4), direction: vector(1, 0, 0))
        XCTAssertEqual(r.position(at: 0), point(2, 3, 4))
        XCTAssertEqual(r.position(at: 1), point(3, 3, 4))
        XCTAssertEqual(r.position(at: -1), point(1, 3, 4))
        XCTAssertEqual(r.position(at: 2.5), point(4.5, 3, 4))
    }

}
