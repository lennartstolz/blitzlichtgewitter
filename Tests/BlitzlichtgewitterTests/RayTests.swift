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

final class RaySphereIntersectionTests : XCTestCase {

    func testARayIntersectsASphereAtTwoPoints() {
        let r = Ray(origin: point(0, 0, -5), direction: vector(0, 0, 1))
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, 4.0)
        XCTAssertEqual(xs[1].t, 6.0)
    }

    func testARayIntersectsASphereAtATangent() {
        let r = Ray(origin: point(0, 1, -5), direction: vector(0, 0, 1))
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, 5.0)
        XCTAssertEqual(xs[1].t, 5.0)
    }

    func testARayMissesASphere() {
        let r = Ray(origin: point(0, 2, -5), direction: vector(0, 0, 1))
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let xs = r.intersect(sphere: s)
        XCTAssertTrue(xs.isEmpty)
    }

    func testARayOriginatesInsideASphere() {
        let r = Ray(origin: point(0, 0, 0), direction: vector(0, 0, 1))
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, -1.0)
        XCTAssertEqual(xs[1].t, 1.0)
    }

    func testASphereBehindARay() {
        let r = Ray(origin: point(0, 0, 5), direction: vector(0, 0, 1))
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, -6.0)
        XCTAssertEqual(xs[1].t, -4.0)
    }

    func testIntersectSetsTheObjectOnTheIntersection() {
        let r = Ray(origin: point(0, 0, -5), direction: vector(0, 0, 1))
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].object, s)
        XCTAssertEqual(xs[1].object, s)
    }

}
