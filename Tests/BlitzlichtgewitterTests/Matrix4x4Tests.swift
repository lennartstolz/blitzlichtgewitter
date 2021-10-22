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

final class Matrix4x4DeterminantTests : XCTestCase {

    func testCalculatingTheDeterminantOfA4x4Matrix() {
        let a = Matrix4x4(rows: [
            [ -2,  -8,   3,   5 ],
            [ -3,   1,   7,   3 ],
            [  1,   2,  -9,   6 ],
            [ -6,   7,   7,  -9 ],
        ])
        XCTAssertEqual(a.cofactor(0, 0), 690)
        XCTAssertEqual(a.cofactor(0, 1), 447)
        XCTAssertEqual(a.cofactor(0, 2), 210)
        XCTAssertEqual(a.cofactor(0, 3), 51)
        XCTAssertEqual(a.determinant, -4071)
    }

}

final class Matrix4x4InversionTests : XCTestCase {

    func testTestingAnInvertibleMAtrixForInvertibility() {
        let a = Matrix4x4(rows: [
            [ 6,   4,   4,   4 ],
            [ 5,   5,   7,   6 ],
            [ 4,  -9,   3,  -7 ],
            [ 9,   1,   7,  -6 ],
        ])
        XCTAssertEqual(a.determinant, -2120)
        XCTAssertTrue(a.isInvertible)
    }

    func testTestingANoninvertibleMatrixForInvertibility() {
        let a = Matrix4x4(rows: [
            [ -4,   2,  -2,  -3 ],
            [  9,   6,   2,   6 ],
            [  0,  -5,   1,  -5 ],
            [  0,   0,   0,   0 ],
        ])
        XCTAssertEqual(a.determinant, 0)
        XCTAssertFalse(a.isInvertible)
    }

    func testCalculatingTheInverseOfAMatrix() {
        let a = Matrix4x4(rows: [
            [ -5,   2,   6,  -8 ],
            [  1,  -5,   1,   8 ],
            [  7,   7,  -6,  -7 ],
            [  1,  -3,   7,   4 ],
        ])
        let b = a.inverse
        XCTAssertEqual(a.determinant, 532)
        XCTAssertEqual(a.cofactor(2, 3), -160)
        XCTAssertEqual(b[3,2], -160/532)
        XCTAssertEqual(a.cofactor(3, 2), 105)
        XCTAssertEqual(b[2,3], 105/532)
        let i = Matrix4x4(rows: [
            [  0.21805,   0.45113,   0.24060,  -0.04511 ],
            [ -0.80827,  -1.45677,  -0.44361,   0.52068 ],
            [ -0.07895,  -0.22368,  -0.05263,   0.19737 ],
            [ -0.52256,  -0.81391,  -0.30075,   0.30639 ],
        ])
        XCTAssertEqual(b, i)
    }

    func testCalculatingTheInverseOfAnotherMatrix() {
        var a = Matrix4x4(rows: [
            [  8,  -5,   9,   2 ],
            [  7,   5,   6,   1 ],
            [ -6,   0,   9,   6 ],
            [ -3,   0,  -9,  -4 ],
        ])
        let i = Matrix4x4(rows: [
            [ -0.15385,  -0.15385,  -0.28205,  -0.53846 ],
            [ -0.07692,   0.12308,   0.02564,   0.03077 ],
            [  0.35897,   0.35897,   0.43590,   0.92308 ],
            [ -0.69231,  -0.69231,  -0.76923,  -1.92308 ],
        ])
        a.invert()
        XCTAssertEqual(a, i)
    }

    func testCalculatingTheInverseOfAThirdMatrix() {
        var a = Matrix4x4(rows: [
            [  9,   3,   0,   9 ],
            [ -5,  -2,  -6,  -3 ],
            [ -4,   9,   6,   4 ],
            [ -7,   6,   6,   2 ],
        ])
        let i = Matrix4x4(rows: [
            [ -0.04074,  -0.07778,   0.14444,  -0.22222 ],
            [ -0.07778,   0.03333,   0.36667,  -0.33333 ],
            [ -0.02901,  -0.14630,  -0.10926,   0.12963 ],
            [  0.17778,   0.06667,  -0.26667,   0.33333 ],
        ])
        a.invert()
        XCTAssertEqual(a, i)
    }

    func testMultiplyingAProductByItsInverse() {
        let a = Matrix4x4(rows: [
            [  3,  -9,   7,   3 ],
            [  3,  -8,   2,  -9 ],
            [ -4,   4,   4,   1 ],
            [ -6,   5,  -1,   1 ],
        ])
        let b = Matrix4x4(rows: [
            [  8,   2,   2,   2 ],
            [  3,  -1,   7,   0 ],
            [  7,   0,   5,   4 ],
            [  6,  -2,   0,   5 ],
        ])
        let c = a * b
        XCTAssertEqual(c * b.inverse, a)
    }

}

// MARK: Chapter 3 - Putting it Together

final class Matrix4x4ExperimentationTests : XCTestCase {

    func testTheInverseOfTheIdentityMatrixIsTheIdentityMatrix() {
        let a = Matrix4x4.identity
        XCTAssertEqual(a.inverse, a)
    }

    func testMultiplyingAMatrixByItsInverseReturnsTheIdentityMatrix() {
        let a = Matrix4x4(rows: [
            [  8,   2,   2,   2 ],
            [  3,  -1,   7,   0 ],
            [  7,   0,   5,   4 ],
            [  6,  -2,   0,   5 ],
        ])
        let i = Matrix4x4(rows: [
            [   0.21428571428571427,   0.14285714285714285,   -0.2857142857142857,   0.14285714285714285 ],
            [ -0.005291005291005291,  -0.31216931216931215,   0.43915343915343913,   -0.3492063492063492 ],
            [  -0.09259259259259259,  0.037037037037037035,   0.18518518518518517,   -0.1111111111111111 ],
            [  -0.25925925925925924,   -0.2962962962962963,    0.5185185185185185,   -0.1111111111111111 ],
        ])
        XCTAssertEqual(a * i, Matrix4x4.identity)
    }

    func testTheTransposeOfTheInverseIsEqualToTheInverseOfTheTranspose() {
        let a = Matrix4x4(rows: [
            [  8,   2,   2,   2 ],
            [  3,  -1,   7,   0 ],
            [  7,   0,   5,   4 ],
            [  6,  -2,   0,   5 ],
        ])
        let b = a.inverse.transposed()
        let c = a.transposed().inverse
        XCTAssertEqual(b, c)
    }

    func testModifyingTheIdentityMatrixAndMultiplyingItWithATuple() {
        var m = Matrix4x4.identity
        m[1, 1] = 14

        var t = tuple(1, 2, 3, 4)
        t = m * t
        XCTAssertEqual(t, tuple(1, 28, 3, 4))
    }

}

final class Matrix4x4TranslationTests  : XCTestCase {

    func testMultiplyingByATranslationMatrix() {
        let transform = translation(5, -3, 2)
        let p = point(-3, 4, 5)
        XCTAssertEqual(transform * p, point(2, 1, 7))
    }

    func testMultiplyingByTheInverseOfATranslationMatrix() {
        let transform = translation(5, -3, 2)
        let i = transform.inverse
        let p = point(-3, 4, 5)
        XCTAssertEqual(i * p, point(-8, 7, 3))
    }

    func testTranslationDoesNotAffectVectors() {
        let transform = translation(5, -3, 2)
        let v = vector(-3, 4, 5)
        XCTAssertEqual(transform * v, v)
    }

}

final class Matrix4x4ScalingTests : XCTestCase {

    func testAScalingMatrixAppliedToAPoint() {
        let transform = scaling(2, 3, 4)
        let p = point(-4, 6, 8)
        XCTAssertEqual(transform * p, point(-8, 18, 32))
    }

    func testAScalingMatrixAppliedToAVector() {
        let transform = scaling(2, 3, 4)
        let v = vector(-4, 6, 8)
        XCTAssertEqual(transform * v, vector(-8, 18, 32))
    }

    func testMultiplyingByTheInverseOfAScalingMatrix() {
        let transform = scaling(2, 3, 4)
        let inv = transform.inverse
        let v = vector(-4, 6, 8)
        XCTAssertEqual(inv * v, vector(-2, 2, 2))
    }

    func testReflectionIsScalingByANegativeValue() {
        let transform = scaling(-1, 1, 1)
        let p = point(2, 3, 4)
        XCTAssertEqual(transform * p, point(-2, 3, 4))
    }

}

final class Matrix4x4RotationTests : XCTestCase {

    func testRotatingAPointAroundTheXAxisByRadians() {
        let p = point(0, 1, 0)
        let half_quarter = rotation_x(rad: .pi / 4)
        let full_quarter = rotation_x(rad: .pi / 2)
        XCTAssertEqual(half_quarter * p, point(0, sqrt(2) / 2, sqrt(2) / 2))
        XCTAssertEqual(full_quarter * p, point(0, 0, 1))
    }

    func testRotatingAPointAroundTheXAxisByDegrees() {
        let p = point(0, 1, 0)
        let half_quarter = rotation_x(deg: 45)
        let full_quarter = rotation_x(deg: 90)
        XCTAssertEqual(half_quarter * p, point(0, sqrt(2) / 2, sqrt(2) / 2))
        XCTAssertEqual(full_quarter * p, point(0, 0, 1))
    }

    func testTheInverseOfAnXRotationRotatesInTheOppositeDirection() {
        let p = point(0, 1, 0)
        let half_quarter = rotation_x(rad: .pi / 4)
        let inv = half_quarter.inverse
        XCTAssertEqual(inv * p, point(0, sqrt(2) / 2, -sqrt(2) / 2))
    }

}
