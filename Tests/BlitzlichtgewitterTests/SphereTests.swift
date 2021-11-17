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

final class SphereNormalTests : XCTestCase {

    func testTheNormalOnASphereAtAPointOnTheXAxis() {
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let n = s.normal(at: point(1, 0, 0))
        XCTAssertEqual(n, vector(1, 0, 0))
    }

    func testTheNormalOnASphereAtAPointOnTheYAxis() {
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let n = s.normal(at: point(0, 1, 0))
        XCTAssertEqual(n, vector(0, 1, 0))
    }

    func testTheNormalOnASphereAtAPointOnTheZAxis() {
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let n = s.normal(at: point(0, 0, 1))
        XCTAssertEqual(n, vector(0, 0, 1))
    }

    func testTheNormalOnASphereAtANonaxialPoint() {
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let n = s.normal(at: point(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3))
        XCTAssertEqual(n, vector(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3))
    }

    func testTheNormalIsANormalizedVector() {
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let n = s.normal(at: point(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3))
        XCTAssertEqual(n, n.normalized())
    }

}
