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
        let s: Sphere = .unit
        XCTAssertEqual(s.transform, .identity)
    }

    func testChagingASpheresTransformation() {
        var s: Sphere = .unit
        let t = translation(2, 3, 4)
        s.transform = t
        XCTAssertEqual(s.transform, t)
    }

}

final class SphereNormalTests : XCTestCase {

    func testTheNormalOnASphereAtAPointOnTheXAxis() {
        let s: Sphere = .unit
        let n = s.normal(at: point(1, 0, 0))
        XCTAssertEqual(n, vector(1, 0, 0))
    }

    func testTheNormalOnASphereAtAPointOnTheYAxis() {
        let s: Sphere = .unit
        let n = s.normal(at: point(0, 1, 0))
        XCTAssertEqual(n, vector(0, 1, 0))
    }

    func testTheNormalOnASphereAtAPointOnTheZAxis() {
        let s: Sphere = .unit
        let n = s.normal(at: point(0, 0, 1))
        XCTAssertEqual(n, vector(0, 0, 1))
    }

    func testTheNormalOnASphereAtANonaxialPoint() {
        let s: Sphere = .unit
        let n = s.normal(at: point(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3))
        XCTAssertEqual(n, vector(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3))
    }

    func testTheNormalIsANormalizedVector() {
        let s: Sphere = .unit
        let n = s.normal(at: point(sqrt(3)/3, sqrt(3)/3, sqrt(3)/3))
        XCTAssertEqual(n, n.normalized())
    }

    func testComputingTheNormalOnATranslatedSphere() {
        var s: Sphere = .unit
        s.transform = translation(0, 1, 0)
        let n = s.normal(at: point(0, 1.70711, -0.70711))
        XCTAssertEqual(n, vector(0, 0.70711, -0.70711))
    }

    func testComputingTheNormalOnATransformedSphere() {
        var s: Sphere = .unit
        let m = scaling(1, 0.5, 1) * rotation_z(rad: .pi / 5)
        s.transform = m
        let n = s.normal(at: point(0, sqrt(2)/2, -sqrt(2)/2))
        XCTAssertEqual(n, vector(0, 0.97014, -0.24254))
    }

}

final class SphereMaterialTests : XCTestCase {

    func testASphereHasADefaultMaterial() {
        let s: Sphere = .unit
        let m = s.material
        XCTAssertEqual(m, Material())
    }

    func testASphereMayBeAssignedAMaterial() {
        var s: Sphere = .unit
        var m = Material()
        m.ambient = 1.0
        s.material = m
        XCTAssertEqual(s.material, m)
    }

}
