import XCTest
import Blitzlichtgewitter

final class SphereTests : XCTestCase {

    func testCreatingASphere() {
        let s = Sphere(origin: point(1, 2, 3), radius: 4)
        XCTAssertEqual(s.origin, point(1, 2, 3))
        XCTAssertEqual(s.radius, 4)
    }

}

final class SphereTransformationTests : XCTestCase {

    func testASpheresDefaultTransformation() {
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        XCTAssertEqual(s.transform, .identity)
    }

    func testChagingASpheresTransformation() {
        var s = Sphere(origin: point(0, 0, 0), radius: 1)
        let t = translation(2, 3, 4)
        s.transform = t
        XCTAssertEqual(s.transform, t)
    }

}
