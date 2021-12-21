import XCTest
import Blitzlichtgewitter

final class IntersectionResultTests : XCTestCase {

    func testAggregatingIntersections() {
        let s: Sphere = .unit
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
        let s: Sphere = .unit
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

final class HitTests : XCTestCase {

    func testTheHitWhenAllIntersectionsHavePositiveT() {
        let s: Sphere = .unit
        let i1 = Intersection(t: 1, object: s)
        let i2 = Intersection(t: 1, object: s)
        let xs = intersections(i1, i2)
        let i = hit(xs)
        XCTAssertEqual(i, i1)
    }

    func testTheHitWhenSomeIntersectionsHaveNegativeT() {
        let s: Sphere = .unit
        let i1 = Intersection(t: -1, object: s)
        let i2 = Intersection(t: 1, object: s)
        let xs = intersections(i1, i2)
        let i = hit(xs)
        XCTAssertEqual(i, i2)
    }

    func testTheHitWhenAllIntersectionsHaveNegativeT() {
        let s: Sphere = .unit
        let i1 = Intersection(t: -2, object: s)
        let i2 = Intersection(t: -1, object: s)
        let xs = intersections(i1, i2)
        let i = hit(xs)
        XCTAssertNil(i)
    }

    func testTheHitIsAlwaysTheLowestNonnegativeIntersection() {
        let s: Sphere = .unit
        let i1 = Intersection(t:  5, object: s)
        let i2 = Intersection(t:  7, object: s)
        let i3 = Intersection(t: -3, object: s)
        let i4 = Intersection(t:  2, object: s)
        let xs = intersections(i1, i2, i3, i4)
        let i = hit(xs)
        XCTAssertEqual(i, i4)
    }

}
