import XCTest
import Blitzlichtgewitter
import BlitzlichtgewitterAssets

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
        let s: Sphere = .unit
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, 4.0)
        XCTAssertEqual(xs[1].t, 6.0)
    }

    func testARayIntersectsASphereAtATangent() {
        let r = Ray(origin: point(0, 1, -5), direction: vector(0, 0, 1))
        let s: Sphere = .unit
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, 5.0)
        XCTAssertEqual(xs[1].t, 5.0)
    }

    func testARayMissesASphere() {
        let r = Ray(origin: point(0, 2, -5), direction: vector(0, 0, 1))
        let s: Sphere = .unit
        let xs = r.intersect(sphere: s)
        XCTAssertTrue(xs.isEmpty)
    }

    func testARayOriginatesInsideASphere() {
        let r = Ray(origin: point(0, 0, 0), direction: vector(0, 0, 1))
        let s: Sphere = .unit
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, -1.0)
        XCTAssertEqual(xs[1].t, 1.0)
    }

    func testASphereBehindARay() {
        let r = Ray(origin: point(0, 0, 5), direction: vector(0, 0, 1))
        let s: Sphere = .unit
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, -6.0)
        XCTAssertEqual(xs[1].t, -4.0)
    }

    func testIntersectSetsTheObjectOnTheIntersection() {
        let r = Ray(origin: point(0, 0, -5), direction: vector(0, 0, 1))
        let s: Sphere = .unit
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].object, s)
        XCTAssertEqual(xs[1].object, s)
    }

}

final class RayTransformationTests : XCTestCase {

    func testTranslatingARay() {
        let r = Ray(origin: point(1, 2, 3), direction: vector(0, 1, 0))
        let m = translation(3, 4, 5)
        let r2 = r.transformed(by: m)
        XCTAssertEqual(r2.origin, point(4, 6, 8))
        XCTAssertEqual(r2.direction, vector(0, 1, 0))
    }

    func testScalingARay() {
        let r = Ray(origin: point(1, 2, 3), direction: vector(0, 1, 0))
        let m = scaling(2, 3, 4)
        let r2 = r.transformed(by: m)
        XCTAssertEqual(r2.origin, point(2, 6, 12))
        XCTAssertEqual(r2.direction, vector(0, 3, 0))
    }

}

final class RayTransformedSphereIntersectionTests : XCTestCase {

    func testIntersectingAScaledSphereWithARay() {
        let r = Ray(origin: point(0, 0, -5), direction: vector(0, 0, 1))
        var s: Sphere = .unit
        s.transform = scaling(2, 2, 2)
        let xs = r.intersect(sphere: s)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, 3)
        XCTAssertEqual(xs[1].t, 7)
    }

}

/// This test case tackles the drawings described in the "Putting It Together" section of the fifth chapter of
/// [The Ray Tracer Challenge pp. 70](http://raytracerchallenge.com/).
///
/// The values are loosely carried over from the books' test scenarios.
final class SphereDrawingTests : XCTestCase {

    /// Exposed to be able to render high-resolution versions of the canvas.
    /// (To keep the unit tests fast, we use a very small canvas size).
    var size: Int!

    override func setUp() {
        super.setUp()
        size = 50
    }

    override func tearDown() {
        size = 0
        super.tearDown()
    }

    func testDrawTranslatedSphere() throws {
        var s: Sphere = .unit
        s.transform = translation(0, 0, 1.5)

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, color: .red)

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "translated-sphere"))

        XCTAssertEqual(canvas, reference)
    }

    func testDrawTranslatedAndScaledSphere() throws {
        var s: Sphere = .unit
        s.transform = scaling(1, 0.5, 1) * translation(0, 0, 1.5)

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, color: [1, 0.65, 0])

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "translated-scaled-sphere"))

        XCTAssertEqual(canvas, reference)
    }

    func testDrawTranslatedScaledAndRotatedSphere() throws {
        var s: Sphere = .unit
        s.transform = rotation_z(rad: .pi / 4) * scaling(1, 0.5, 1) * translation(0, 0, 1.5)

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, color: [0.75, 1, 0])

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "translated-scaled-rotated-sphere"))

        XCTAssertEqual(canvas, reference)
    }

    func testDrawTranslatedScaledAndSkewedSphere() throws {
        var s: Sphere = .unit
        s.transform = shearing(1, 0, 0, 0, 0, 0) * scaling(0.5, 1, 1) * translation(0, 0, 1.5)

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, color: [0.5, 1, 0.8])

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "translated-scaled-skewed-sphere"))

        XCTAssertEqual(canvas, reference)
    }

}

private extension Canvas {

    /// Simple method to draw a sphere with a primitive "3D Look" on a canvas.
    mutating func draw(sphere: Sphere, color: Color) {
        assert(width == height)
        for y in 0..<height {
            for x in 0..<width {

                let center = Double((width - 1) / 2)

                let dx = (Double(x) - center) / center
                let dy = (center - Double(y)) / center

                let d = vector(dx, dy, 1)
                let r = Ray(origin: point(0, 0, 0), direction: d)
                let xs = r.intersect(sphere: sphere)
                if let hit = hit(xs) {
                    let i = 0.9 - hit.t
                    self[x, y] = [color.red * i, color.green * i, color.blue * i]
                }
            }
        }

    }

    /// Returns a canvas with clamped color values to compare the canvas with a reference image.
    func drawn() -> Self? {
        guard let data = ppmData() else { return nil }
        return Self(data: data)
    }

}
