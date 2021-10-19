import XCTest
import Blitzlichtgewitter

final class Matrix3x3Tests : XCTestCase {

    func testConstructingAndInspectingA3x3Matrix() {
        let m = Matrix3x3(rows: [
            [ -3,   5,  0 ],
            [  1,  -2, -7 ],
            [  0,   1,  1 ],
        ])
        XCTAssertEqual(m[0, 0], -3)
        XCTAssertEqual(m[0, 1],  5)
        XCTAssertEqual(m[0, 2],  0)
        XCTAssertEqual(m[1, 0],  1)
        XCTAssertEqual(m[1, 1], -2)
        XCTAssertEqual(m[1, 2], -7)
        XCTAssertEqual(m[2, 0],  0)
        XCTAssertEqual(m[2, 1],  1)
        XCTAssertEqual(m[2, 2],  1)
    }

}

final class Matrix3x3ComparisonTests : XCTestCase {

    func testComparingEqualMatrices() {
        let m1 = Matrix3x3(rows: [
            [ 2,  0,  0 ],
            [ 0,  2,  0 ],
            [ 0,  0,  2 ],
        ])
        let m2 = Matrix3x3(rows: [
            [ 2,  0,  0 ],
            [ 0,  2,  0 ],
            [ 0,  0,  2 ],
        ])
        XCTAssertEqual(m1, m2)
    }

    func testComparingVerySimilarMatrices() {
        let m1 = Matrix3x3(rows: [
            [ 2,  0,  0 ],
            [ 0,  2,  0 ],
            [ 0,  0,  2 ],
        ])
        let m2 = Matrix3x3(rows: [
            [ 2,  0,         0 ],
            [ 0,  2,         0 ],
            [ 0,  0,  2.000001 ],
        ])
        XCTAssertEqual(m1, m2)
    }

    func testComparingDifferentMatrices() {
        let m1 = Matrix3x3(rows: [
            [ 1,  0,  0 ],
            [ 0,  1,  0 ],
            [ 0,  0,  1 ],
        ])
        let m2 = Matrix3x3(rows: [
            [ 2,  0,  0 ],
            [ 0,  2,  0 ],
            [ 0,  0,  2 ],
        ])
        XCTAssertNotEqual(m1, m2)
    }

}
