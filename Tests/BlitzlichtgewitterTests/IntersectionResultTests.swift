import XCTest
import Blitzlichtgewitter

final class IntersectionResultTests : XCTestCase {

    func testAggregatingIntersections() {
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let i1 = Intersection(t: 1, object: s)
        let i2 = Intersection(t: 2, object: s)
        let xs = intersections(i1, i2)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, 1)
        XCTAssertEqual(xs[1].t, 2)
    }

    func testAggregatingIntersectionResults() {
        let r1 = Ray(origin: point(0, 0, 0), direction: vector(0, 0, 1))
        let r2 = Ray(origin: point(0, 0, -5), direction: vector(0, 0, 1))
        let s = Sphere(origin: point(0, 0, 0), radius: 1)
        let xs1 = r1.intersect(sphere: s)
        let xs2 = r2.intersect(sphere: s)
        let xs = intersections(xs1, xs2)
        XCTAssertEqual(xs.count,   4)
        XCTAssertEqual(xs[0].t, -1.0)
        XCTAssertEqual(xs[1].t,  1.0)
        XCTAssertEqual(xs[2].t,  4.0)
        XCTAssertEqual(xs[3].t,  6.0)
    }

}
