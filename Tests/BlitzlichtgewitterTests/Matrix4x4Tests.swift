import XCTest
import Blitzlichtgewitter

final class Matrix4x4Tests : XCTestCase {

    func testConstructingAndInspectingA4x4Matrix() {
        let m = Matrix4x4(rows: [
            [    1,     2,     3,     4 ],
            [  5.5,   6.5,   7.5,   8.5 ],
            [    9,    10,    11,    12 ],
            [ 13.5,  14.5,  15.5,  16.5 ],
        ])
        XCTAssertEqual(m[0,0],    1)
        XCTAssertEqual(m[0,1],    2)
        XCTAssertEqual(m[0,2],    3)
        XCTAssertEqual(m[0,3],    4)
        XCTAssertEqual(m[1,0],  5.5)
        XCTAssertEqual(m[1,1],  6.5)
        XCTAssertEqual(m[1,2],  7.5)
        XCTAssertEqual(m[1,3],  8.5)
        XCTAssertEqual(m[2,0],    9)
        XCTAssertEqual(m[2,1],   10)
        XCTAssertEqual(m[2,2],   11)
        XCTAssertEqual(m[2,3],   12)
        XCTAssertEqual(m[3,0], 13.5)
        XCTAssertEqual(m[3,1], 14.5)
        XCTAssertEqual(m[3,2], 15.5)
        XCTAssertEqual(m[3,3], 16.5)
    }

}

final class Matrix4x4ComparisonTests : XCTestCase {

    func testComparingEqualMatrices() {
        let m1 = Matrix4x4(rows: [
            [ 2,  0,  0,  0 ],
            [ 0,  2,  0,  0 ],
            [ 0,  0,  2,  0 ],
            [ 0,  0,  0,  2 ],
        ])
        let m2 = Matrix4x4(rows: [
            [ 2,  0,  0,  0 ],
            [ 0,  2,  0,  0 ],
            [ 0,  0,  2,  0 ],
            [ 0,  0,  0,  2 ],
        ])
        XCTAssertEqual(m1, m2)
    }

    func testComparingVerySimilarMatrices() {
        let m1 = Matrix4x4(rows: [
            [ 2,  0,  0,  0 ],
            [ 0,  2,  0,  0 ],
            [ 0,  0,  2,  0 ],
            [ 0,  0,  0,  2 ],
        ])
        let m2 = Matrix4x4(rows: [
            [ 1.9999999,  0,  0,  0 ],
            [         0,  2,  0,  0 ],
            [         0,  0,  2,  0 ],
            [         0,  0,  0,  2 ],
        ])
        XCTAssertEqual(m1, m2)
    }

    func testComparingDifferentMatrices() {
        let m1 = Matrix4x4(rows: [
            [ 1,  0,  0,  0 ],
            [ 0,  1,  0,  0 ],
            [ 0,  0,  1,  0 ],
            [ 0,  0,  0,  1 ],
        ])
        let m2 = Matrix4x4(rows: [
            [ 2,  0,  0,  0 ],
            [ 0,  2,  0,  0 ],
            [ 0,  0,  2,  0 ],
            [ 0,  0,  0,  2 ],
        ])
        XCTAssertNotEqual(m1, m2)
    }

}

final class Matrix4x4MultiplicationTests : XCTestCase {

    func testMultiplyingTwoMatrices() {
        let m1 = Matrix4x4(rows: [
            [  1,   2,   3,   4 ],
            [  5,   6,   7,   8 ],
            [  9,   8,   7,   6 ],
            [  5,   4,   3,   2 ],
        ])
        let m2 = Matrix4x4(rows: [
            [ -2,   1,   2,   3 ],
            [  3,   2,   1,  -1 ],
            [  4,   3,   6,   5 ],
            [  1,   2,   7,   8 ],
        ])
        let product = Matrix4x4(rows: [
            [ 20,  22,   50,   48 ],
            [ 44,  54,  114,  108 ],
            [ 40,  58,  110,  102 ],
            [ 16,  26,   46,   42 ],
        ])
        XCTAssertEqual(m1 * m2, product)
    }

    func testAMatrixMultipliedByATuples() {
        let m = Matrix4x4(rows: [
            [ 1,  2,  3,  4 ],
            [ 2,  4,  4,  2 ],
            [ 8,  6,  4,  1 ],
            [ 0,  0,  0,  1 ],
        ])
        let t = tuple(1, 2, 3, 1)
        XCTAssertEqual(m * t, tuple(18, 24, 33, 1))
    }

}

final class Matrix4x4IdentityTests : XCTestCase {

    func testMultiplyingAMatrixByTheIdentityMatrix() {
        let m = Matrix4x4(rows: [
            [ 0,   1,   2,   3 ],
            [ 1,   2,   4,   8 ],
            [ 2,   4,   8,  16 ],
            [ 4,   8,  16,  32 ],
        ])
        XCTAssertEqual(m * .identity, m)
    }

    func testMultiplyingTheIdentityMatrixByATuple() {
        let t = tuple(1, 2, 3, 4)
        XCTAssertEqual(Matrix4x4.identity * t, t)
    }

}

final class Matrix4x4TransposingTests : XCTestCase {

    func testTransposingAMatrix() {
        let m = Matrix4x4(rows: [
            [ 0,  9,  3,  0 ],
            [ 9,  8,  0,  8 ],
            [ 1,  8,  5,  3 ],
            [ 0,  0,  5,  8 ],
        ])
        let r = Matrix4x4(rows: [
            [ 0,  9,  1,  0 ],
            [ 9,  8,  8,  0 ],
            [ 3,  0,  5,  5 ],
            [ 0,  8,  3,  8 ],
        ])
        XCTAssertEqual(m.transposed(), r)
    }

    func testMutatingTranspsingAMatrix() {
        var m = Matrix4x4(rows: [
            [ 0,  9,  3,  0 ],
            [ 9,  8,  0,  8 ],
            [ 1,  8,  5,  3 ],
            [ 0,  0,  5,  8 ],
        ])
        m.transpose()
        let r = Matrix4x4(rows: [
            [ 0,  9,  1,  0 ],
            [ 9,  8,  8,  0 ],
            [ 3,  0,  5,  5 ],
            [ 0,  8,  3,  8 ],
        ])
        XCTAssertEqual(m, r)
    }

    func testTransposingTheIdentityMatrix() {
        XCTAssertEqual(Matrix4x4.identity.transposed(), Matrix4x4.identity)
    }

}

final class Matrix4x4SubmatricesTests : XCTestCase {

    func testASubmatrixOfA4x4MatrixIsA3x3Matrix() {
        let a = Matrix4x4(rows: [
            [ -6,   1,   1,   6 ],
            [ -8,   5,   8,   6 ],
            [ -1,   0,   8,   2 ],
            [ -7,   1,  -1,   1 ],
        ])
        let s = Matrix3x3(rows: [
            [ -6,   1,   6 ],
            [ -8,   8,   6 ],
            [ -7,  -1,   1 ]
        ])
        XCTAssertEqual(a.submatrix(2, 1), s)
    }

}
