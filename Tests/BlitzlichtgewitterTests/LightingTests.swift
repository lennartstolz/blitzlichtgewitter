import XCTest
import Blitzlichtgewitter

final class LightningTests : XCTestCase {

    var m: Material!

    var position: Tuple!

    // MARK: Test Setup

    override func setUp() {
        super.setUp()
        m = Material()
        position = point(0, 0, 0)
    }

    override func tearDown() {
        m = nil
        position = nil
        super.tearDown()
    }

    // MARK: Test Cases

    func testLightingWithTheEyeBetweenTheLightAndTheSurface() {
        let eyeVector = vector(0, 0, -1)
        let normalVector = vector(0, 0, -1)
        let light = PointLight(position: point(0, 0, -10), intensity: [1, 1, 1])
        let result = lighting(m, light, position, eyeVector, normalVector)
        XCTAssertEqual(result, [ 1.9, 1.9, 1.9 ])
    }

    func testLightingWithTheEyeBetweenLightAndSurfaceEyeOffset45Degree() {
        let eyeVector = vector(0, sqrt(2)/2, -sqrt(2)/2)
        let normalVector = vector(0, 0, -1)
        let light = PointLight(position: point(0, 0, -10), intensity: [1, 1, 1])
        let result = lighting(m, light, position, eyeVector, normalVector)
        XCTAssertEqual(result, [ 1.0, 1.0, 1.0 ])
    }

    func testLightingWithEyeOppositeSurfaceLightOffset45Degree() {
        let eyeVector = vector(0, 0, -1)
        let normalVector = vector(0, 0, -1)
        let light = PointLight(position: point(0, 10, -10), intensity: [1, 1, 1])
        let result = lighting(m, light, position, eyeVector, normalVector)
        XCTAssertEqual(result, [ 0.7364, 0.7364, 0.7364 ])
    }

    func testLightingWithEyeInThePathOfTheReflectionVector() {
        let eyeVector = vector(0, -sqrt(2)/2, -sqrt(2)/2)
        let normalVector = vector(0, 0, -1)
        let light = PointLight(position: point(0, 10, -10), intensity: [1, 1, 1])
        let result = lighting(m, light, position, eyeVector, normalVector)
        XCTAssertEqual(result, [ 1.6364, 1.6364, 1.6364 ])
    }

    func testLightingWithTheLightBehindTheSurface() {
        let eyeVector = vector(0, 0, -1)
        let normalVector = vector(0, 0, -1)
        let light = PointLight(position: point(0, 0, 10), intensity: [1, 1, 1])
        let result = lighting(m, light, position, eyeVector, normalVector)
        XCTAssertEqual(result, [ 0.1, 0.1, 0.1 ])
    }

}

/// This test case tackles the drawings described in the "Putting It Together" section of the sixth chapter of
/// [The Ray Tracer Challenge pp. 89](http://raytracerchallenge.com/).
final class LightningRenderingTests : XCTestCase {

    /// Exposed to be able to render high-resolution versions of the canvas.
    /// (To keep the unit tests fast, we use a very small canvas size).
    var size: Int!

    // MARK: Test Setup

    override func setUp() {
        super.setUp()
        size = 50
    }

    override func tearDown() {
        size = 0
        super.tearDown()
    }

    // MARK: Test Cases

    func testDrawTranslatedSphere() throws {

        var s: Sphere = .unit
        s.transform = translation(0, 0, 1.5)

        s.material.color = .greenery

        let light = PointLight(position: point(-10, 10, -10), intensity: [1, 1, 1])

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, light: light)

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "phong-translated-sphere"))

        XCTAssertEqual(canvas, reference)
    }

    func testDrawTranslatedAndScaledSphere() throws {
        var s: Sphere = .unit
        s.transform = scaling(1, 0.5, 1) * translation(0, 0, 1.5)
        s.material.color = .livingCoral

        let light = PointLight(position: point(-10, 10, -10), intensity: [1, 1, 1])

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, light: light)

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "phong-translated-scaled-sphere"))

        XCTAssertEqual(canvas, reference)
    }

    func testDrawTranslatedScaledAndRotatedSphere() throws {
        var s: Sphere = .unit
        s.transform = rotation_z(rad: .pi / 4) * scaling(1, 0.5, 1) * translation(0, 0, 1.5)
        s.material.color = .classicBlue

        let light = PointLight(position: point(-10, 10, -10), intensity: [1, 1, 1])

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, light: light)

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "phong-translated-scaled-rotated-sphere"))

        XCTAssertEqual(canvas, reference)
    }

    func testDrawTranslatedScaledAndSkewedSphere() throws {
        var s: Sphere = .unit
        s.transform = shearing(1, 0, 0, 0, 0, 0) * scaling(0.5, 1, 1) * translation(0, 0, 2)
        s.material.color = .ultraViolet

        let light = PointLight(position: point(-10, 10, -10), intensity: [1, 1, 1])

        var c = Canvas(width: size, height: size, color: .black)
        c.draw(sphere: s, light: light)

        let canvas =  try XCTUnwrap(c.drawn())
        let reference = try XCTUnwrap(Canvas(testResourceNamed: "phong-translated-scaled-skewed-sphere"))

        XCTAssertEqual(canvas, reference)
    }

}

private extension Canvas {

    /// Simple method to draw a sphere with a primitive phong shading for the given point light on the canvas.
    mutating func draw(sphere: Sphere, light: PointLight) {
        assert(width == height)
        for y in 0..<height {
            for x in 0..<width {

                let center = Double((width - 1) / 2)

                let dx = (Double(x) - center) / center
                let dy = (center - Double(y)) / center

                let d = vector(dx, dy, 1).normalized()
                let r = Ray(origin: point(0, 0, 0), direction: d)
                let xs = r.intersect(sphere: sphere)
                if let hit = hit(xs) {
                    let point = r.position(at: hit.t)
                    let normal = hit.object.normal(at: point)
                    let eye = -r.direction
                    self[x, y] = lighting(hit.object.material, light, point, eye, normal)
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

/// Colors of the Year
///
/// https://www.w3schools.com/colors/colors_trends.asp
private extension Color {

    /// 2020s "Color of the Year" (#34568B)
    static let classicBlue : Color = [ 52.0 / 255.0, 86.0 / 255.0, 139.0 / 255.0 ]

    /// 2019s "Color of the Year" (#FF6F61)
    static let livingCoral : Color = [ 255.0 / 255.0, 111.0 / 255.0, 97.0 / 255.0 ]

    /// 2018s "Color of the Year" (#6B5B95)
    static let ultraViolet : Color = [ 107.0 / 255.0, 91.0 / 255.0, 149.0 / 255.0 ]

    /// 2017s "Color of the Year" (#88B04B)
    static let greenery : Color = [ 136.0 / 255.0, 176.0 / 255.0, 75.0 / 255.0 ]

}
