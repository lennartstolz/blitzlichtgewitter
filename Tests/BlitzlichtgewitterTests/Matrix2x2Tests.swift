import XCTest
import Blitzlichtgewitter

final class Matrix2x2Tests : XCTestCase {

    func testConstructingAndInspectingA2x2Matrix() {
        let m = Matrix2x2(rows: [
            [ -3,   5 ],
            [  1,  -2 ],
        ])
        XCTAssertEqual(m[0, 0], -3)
        XCTAssertEqual(m[0, 1],  5)
        XCTAssertEqual(m[1, 0],  1)
        XCTAssertEqual(m[1, 1], -2)
    }

}

final class Matrix2x2ComparisonTests : XCTestCase {

    func testComparingEqualMatrices() {
        let m1 = Matrix2x2(rows: [
            [ 1,  0 ],
            [ 0,  1 ],
        ])
        let m2 = Matrix2x2(rows: [
            [ 1,  0 ],
            [ 0,  1 ],
        ])
        XCTAssertEqual(m1, m2)
    }

    func testComparingVerySimilarMatrices() {
        let m1 = Matrix2x2(rows: [
            [ 1,  0 ],
            [ 0,  1 ],
        ])
        let m2 = Matrix2x2(rows: [
            [ 1,         0 ],
            [ 0,  0.999999 ],
        ])
        XCTAssertEqual(m1, m2)
    }

    func testComparingDifferentMatrices() {
        let m1 = Matrix2x2(rows: [
            [ 1,  1 ],
            [ 1,  1 ],
        ])
        let m2 = Matrix2x2(rows: [
            [ 1,  0 ],
            [ 1,  0 ],
        ])
        XCTAssertNotEqual(m1, m2)
    }

}
