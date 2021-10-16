import XCTest
import Blitzlichtgewitter
import BlitzlichtgewitterAssets

final class CanvasTests : XCTestCase {

    func testCreatingACanvas() {
        let c = Canvas(width: 10, height: 20)
        XCTAssertEqual(c.width, 10)
        XCTAssertEqual(c.height, 20)
        for x in 0..<10 {
            for y in 0..<20 {
                XCTAssertEqual(c[x, y], .black)
            }
        }
    }

    func testWritingPixelsToACanvas() {
        var c = Canvas(width: 10, height: 20)
        c[2, 3] = .red
        XCTAssertEqual(c[2, 3], .red)
    }

}

final class CanvasSavingTests : XCTestCase {

    func testConstructingThePPMHeader() throws {
        let c = Canvas(width: 5, height: 3)
        let ppm = try XCTUnwrap(c.ppmData())
        let rawData = try XCTUnwrap(String(data: ppm, encoding: .ascii))
        let header = rawData.lines(1...3)
        let expectedHeader = """
        P3
        5 3
        255
        """
        XCTAssertEqual(header, expectedHeader)
    }

    func testConstructingThePPMPixelData() throws {
        var c = Canvas(width: 5, height: 3)
        c[0, 0] = [1.5, 0, 0]
        c[2, 1] = [0, 0.5, 0]
        c[4, 2] = [-0.5, 0, 1]

        let ppm = try XCTUnwrap(c.ppmData())

        let rawData = try XCTUnwrap(String(data: ppm, encoding: .ascii))
        let pixelData = rawData.lines(4...6)
        let expectedPixelData = """
        255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
        """
        XCTAssertEqual(pixelData, expectedPixelData)
    }

    func testSplittingLongLinesInPPMFiles() throws {
        let c = Canvas(width: 10, height: 2, color: [1, 0.8, 0.6])
        let ppm = try XCTUnwrap(c.ppmData())
        let rawData = try XCTUnwrap(String(data: ppm, encoding: .ascii))
        let pixelData = rawData.lines(4...7)
        let expectedPixelData = """
        255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
        153 255 204 153 255 204 153 255 204 153 255 204 153
        255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
        153 255 204 153 255 204 153 255 204 153 255 204 153
        """
        XCTAssertEqual(pixelData, expectedPixelData)
    }

    func testPPMFilesAreTerminatedByANewlineCharacter() throws {
        let c = Canvas(width: 5, height: 3)
        let ppm = try XCTUnwrap(c.ppmData())
        let rawData = try XCTUnwrap(String(data: ppm, encoding: .ascii))
        XCTAssertTrue(rawData.hasSuffix("\n"))
    }

}

final class CanvasLoadingTests : XCTestCase {

    func testLoadingTheCorrectSize() throws {
        let canvas = try XCTUnwrap(Canvas(testResourceNamed: "red-green-blue-reference-image"))
        XCTAssertEqual(canvas.width, 3)
        XCTAssertEqual(canvas.height, 1)
    }

    func testLoadingTheCorrectPixelData() throws {
        let canvas = try XCTUnwrap(Canvas(testResourceNamed: "red-green-blue-reference-image"))
        XCTAssertEqual(canvas[0, 0], .red)
        XCTAssertEqual(canvas[1, 0], .green)
        XCTAssertEqual(canvas[2, 0], .blue)
    }

}

/// This test case tackles the "Putting It Together" sections of the first and second chapter of
/// [The Ray Tracer Challenge pp. 23](http://raytracerchallenge.com/) and renders multiple trajectories of a projectile
///  in different environments. The values are loosely carried over from the books' test scenarios.
final class CanvasProjectileTrajectoryRenderTests : XCTestCase {

    func testDrawingProjectileTrajectory() throws {

        let p = Projectile(position: point(0, 1, 0), velocity: vector(1, 1.8, 0).normalized() * 11.25)
        let e0 = Environment(gravity: vector(0, -0.1, 0), wind: vector(0, 0, 0))
        let e1 = Environment(gravity: vector(0, -0.2, 0), wind: vector(-0.01, 0, 0))
        let e2 = Environment(gravity: vector(0, -0.1, 0), wind: vector(-0.02, 0, 0))
        let e3 = Environment(gravity: vector(0, -0.1, 0), wind: vector(-0.04, 0, 0))
        let e4 = Environment(gravity: vector(0, -0.1, 0), wind: vector(-0.08, 0, 0))
        let e5 = Environment(gravity: vector(0, -0.2, 0), wind: vector(0.04, 0, 0))
        let e6 = Environment(gravity: vector(0, -0.2, 0), wind: vector(0.08, 0, 0))

        var canvas = Canvas(width: 1100, height: 500)
        draw(projectile: p, environment: e0, in: .white, on: &canvas)
        draw(projectile: p, environment: e1, in: [1, 1, 0], on: &canvas)
        draw(projectile: p, environment: e2, in: .red, on: &canvas)
        draw(projectile: p, environment: e3, in: .green, on: &canvas)
        draw(projectile: p, environment: e4, in: .blue, on: &canvas)
        draw(projectile: p, environment: e5, in: [0, 1, 1], on: &canvas)
        draw(projectile: p, environment: e6, in: [1, 0, 1], on: &canvas)

        let reference = try XCTUnwrap(Canvas(testResourceNamed: "projectile-trajectory-reference-image"))
        XCTAssertEqual(canvas, reference)
    }

    private struct Projectile {

        let position: Tuple

        let velocity: Tuple

        init(position: Tuple, velocity: Tuple) {
            assert(position.isPoint)
            assert(velocity.isVector)
            self.position = position
            self.velocity = velocity
        }

    }

    private struct Environment {

        let gravity: Tuple

        let wind: Tuple

        init(gravity: Tuple, wind: Tuple) {
            assert(gravity.isVector)
            assert(wind.isVector)
            self.gravity = gravity
            self.wind = wind
        }

    }

    private func draw(projectile: Projectile, environment: Environment, in color: Color, on canvas: inout Canvas) {
        var projectile = projectile
        while projectile.position.y >= 0 && projectile.position.x >= 0 {
            let x = Int(projectile.position.x)
            let y = canvas.height - Int(projectile.position.y)
            if canvas[x, y] != .black {
                canvas[x, y] = canvas[x, y] * color
            } else {
                canvas[x, y] = color
            }
            projectile = tick(environment: environment, projectile: projectile)
        }
    }

    private func tick(environment: Environment, projectile: Projectile) -> Projectile {
        let position = projectile.position + projectile.velocity
        let velocity = projectile.velocity + environment.gravity + environment.wind
        return Projectile(position: position, velocity: velocity)
    }

}

private extension String {

    /// Returns the section of the text in the given lines.
    ///
    /// This method simplifies the testing of the PPM files. It offers the API the test scenarios expect according to
    /// [The Ray Tracer Challenge](http://raytracerchallenge.com/) by Jamis Buck.
    ///
    /// - Parameters:
    ///     - range: The range (1-indexed) of the text secion.
    ///
    /// - Retuns: The section of the text in the given lines.
    func lines(_ range: ClosedRange<Int>) -> Self {
        let zeroBasedRange:Range<Int> = ((range.lowerBound - 1)..<range.upperBound)
        return components(separatedBy: .newlines)[zeroBasedRange].reduce("") { $0.isEmpty ? $1 : $0 + "\n" + $1 }
    }


    /// Returns the section of the text in the given line.
    ///
    /// This method simplifies the parsing of the PPM files.
    ///
    /// - Parameters:
    ///     - number: The line (1-indexed) of the text.
    ///
    /// - Retuns: The section of the text in the given line.
    func line(_ number: Int) -> Self { lines(number...number) }

}

private extension Canvas {

    /// Initializes and returns the canvas from the specified resource from the test bundles `Resources` directory.
    ///
    /// - Parameters:
    ///     - name: The name of the `.ppm` file stored in the test bundles `Resources` subdirectory.
    init?(testResourceNamed name: String) {
        guard
            let url = Assets.url(forResource: name, withExtension: ".ppm"),
            let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        self.init(data: data)
    }

}
