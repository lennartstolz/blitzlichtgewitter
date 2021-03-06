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

final class Matrix3x3SubmatricesTests : XCTestCase {

    func testASubmatrixOfA3x3MatrixIsA2x2Matrix() {
        let a = Matrix3x3(rows: [
            [  1,   5,   0 ],
            [ -3,   2,   7 ],
            [  0,   6,  -3 ],
        ])
        let s = Matrix2x2(rows: [
            [ -3,  2 ],
            [  0,  6 ],
        ])
        XCTAssertEqual(a.submatrix(0, 2), s)
    }

}

final class Matrix3x3MinorTests : XCTestCase {

    func testCalculatingAMinorOfA3x3Matrix() {
        let a = Matrix3x3(rows: [
            [ 3,   5,   0 ],
            [ 2,  -1,  -7 ],
            [ 6,  -1,   5 ],
        ])
        let s = Matrix2x2(rows: [
            [  5,  0 ],
            [ -1,  5 ],
        ])
        XCTAssertEqual(a.submatrix(1, 0), s)
        XCTAssertEqual(s.determinant, 25)
        XCTAssertEqual(a.minor(1, 0), 25)
    }

}

final class Matrix3x3CofactorTests : XCTestCase {

    func testCalculatingACofactorOfA3x3Matrix() {
        let a = Matrix3x3(rows: [
            [ 3,   5,   0 ],
            [ 2,  -1,  -7 ],
            [ 6,  -1,   5 ],
        ])
        XCTAssertEqual(a.minor(0, 0), -12)
        XCTAssertEqual(a.cofactor(0, 0), -12)
        XCTAssertEqual(a.minor(1, 0), 25)
        XCTAssertEqual(a.cofactor(1, 0), -25)
    }

}

final class Matrix3x3DeterminantTests : XCTestCase {

    func testCalculatingTheDeterminantOfA3x3Matrix() {
        let a = Matrix3x3(rows: [
            [  1,   2,   6 ],
            [ -5,   8,  -4 ],
            [  2,   6,   4 ],
        ])
        XCTAssertEqual(a.cofactor(0, 0), 56)
        XCTAssertEqual(a.cofactor(0, 1), 12)
        XCTAssertEqual(a.cofactor(0, 2), -46)
        XCTAssertEqual(a.determinant, -196)
    }

}
