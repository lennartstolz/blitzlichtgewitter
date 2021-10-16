import XCTest
import Blitzlichtgewitter

final class ColorTests : XCTestCase {

    func testColorsAreRedGreenBlueTuples() {
        let c: Color = [-0.5, 0.4, 1.7]
        XCTAssertEqual(c.red, -0.5)
        XCTAssertEqual(c.green, 0.4)
        XCTAssertEqual(c.blue, 1.7)
    }

}

final class ColorAdditionTests : XCTestCase {

    func testAddingColors() {
        let c1: Color = [0.9, 0.6, 0.75]
        let c2: Color = [0.7, 0.1, 0.25]
        XCTAssertEqual(c1 + c2, [1.6, 0.7, 1.0])
    }

}

final class ColorSubstractingTests : XCTestCase {

    func testSubstractingColors() {
        let c1: Color = [0.9, 0.6, 0.75]
        let c2: Color = [0.7, 0.1, 0.25]
        XCTAssertEqual(c1 - c2, [0.2, 0.5, 0.5])
    }

}

final class ColorScalarMultiplicationTests : XCTestCase {

    func testMultiplyingAColorByAScalar() {
        let c: Color = [0.2, 0.3, 0.4]
        XCTAssertEqual(c * 2, [0.4, 0.6, 0.8])
    }

}

final class ColorMultiplicationTests : XCTestCase {

    func testMultiplyingColors() {
        let c1: Color = [1.0, 0.2, 0.4]
        let c2: Color = [0.9, 1, 0.1]
        XCTAssertEqual(c1 * c2, [0.9, 0.2, 0.04])
    }

}
