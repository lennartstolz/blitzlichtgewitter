import XCTest
import Blitzlichtgewitter

final class TupleTests : XCTestCase {

    func testATupleWithWEqualsOneIsAPoint() {
        let t = tuple(4.3, -4.2, 3.1, 1.0)
        XCTAssertTrue(t.isPoint)
        XCTAssertFalse(t.isVector)
    }

    func testATupleWithWEqualsZeroIsAVector() {
        let t = tuple(4.3, -4.2, 3.1, 0.0)
        XCTAssertTrue(t.isVector)
        XCTAssertFalse(t.isPoint)
    }

    // MARK: - Factory Method Tests

    func testPointCreatesTuplesWithWEqualsOne() {
        let point = point(4.3, -4.2, 3.1)
        XCTAssertTrue(point.isPoint)
        XCTAssertFalse(point.isVector)
    }

    func testVectorCreatesTuplesWithWEqualsZero() {
        let vector = vector(4.3, -4.2, 3.1)
        XCTAssertTrue(vector.isVector)
        XCTAssertFalse(vector.isPoint)
    }

}

final class TupleAddingTests : XCTestCase {

    func testAddingTwoTuples() {
        let a1 = tuple(3, -2, 5, 1)
        let a2 = tuple(-2, 3, 1, 0)
        XCTAssertEqual(a1 + a2, tuple(1, 1, 6, 1))
    }

    func testAddingAVectorToAPoint() {
        let v = vector(5, 6, 7)
        let p = point(3, 2, 1)
        XCTAssertEqual(v + p, point(8, 8, 8))
    }

    func testAddingAPointToAVector() {
        let p = point(3, 2, 1)
        let v = vector(5, 6, 7)
        XCTAssertEqual(p + v, point(8, 8, 8))
    }

    func testAddingTwoVectors() {
        let v1 = vector(3, 2, 1)
        let v2 = vector(5, 6, 7)
        XCTAssertEqual(v1 + v2, vector(8, 8, 8))
    }

}

final class TupleSubstractingTests : XCTestCase {

    func testSubstractingTwoPoints() {
        let p1 = point(3, 2, 1)
        let p2 = point(5, 6, 7)
        XCTAssertEqual(p1 - p2, vector(-2, -4, -6))
    }

    func testSubstractingAVectorFromAPoint() {
        let p = point(3, 2, 1)
        let v = vector(5, 6, 7)
        XCTAssertEqual(p - v, point(-2, -4, -6))
    }

    func testSubstractingTwoVectors() {
        let v1 = vector(3, 2, 1)
        let v2 = vector(5, 6, 7)
        XCTAssertEqual(v1 - v2, vector(-2, -4, -6))
    }

}

final class TupleNegatingTests : XCTestCase {

    func testSubstractingAVectorFromAZeroVector() {
        let zero = Tuple.zero
        let v = vector(1, -2, 3)
        XCTAssertEqual(zero - v, vector(-1, 2, -3))
    }

    func testNegatingATuple() {
        let t = tuple(1, -2, 3, -4)
        XCTAssertEqual(-t, tuple(-1, 2, -3, 4))
    }

}

final class TupleScalarMultiplicationTests : XCTestCase {

    func testMultiplyingATupleByAScalar() {
        let a = tuple(1, -2, 3, -4)
        XCTAssertEqual(a * 3.5, tuple(3.5, -7, 10.5, -14))
    }

}

final class TupleScalarDivisionTests : XCTestCase {

    func testDividingATupleByAScalar() {
        let a = tuple(1, -2, 3, -4)
        XCTAssertEqual(a / 2, tuple(0.5, -1, 1.5, -2))
    }

}

final class TupleMagnituteTests : XCTestCase {

    func testComputingTheMagnituteOfVector100() {
        let v = vector(1, 0, 0)
        XCTAssertEqual(v.magnitude, 1)
    }

    func testComputingTheMagnituteOfVector010() {
        let v = vector(0, 1, 0)
        XCTAssertEqual(v.magnitude, 1)
    }

    func testComputingTheMagnituteOfVector001() {
        let v = vector(0, 0, 1)
        XCTAssertEqual(v.magnitude, 1)
    }

    func testComputingTheMagnituteOfVector123() {
        let v = vector(1, 2, 3)
        XCTAssertEqual(v.magnitude, 3.7416573868, accuracy: 0.00001)
    }

    func testComputingTheMagnituteOfNegatedVector123() {
        let v = vector(-1, -2, -3)
        XCTAssertEqual(v.magnitude, 3.7416573868, accuracy: 0.00001)
    }

}

final class TupleNormalizationTests : XCTestCase {

    func testNormalizingVector400() {
        let v = vector(4, 0, 0)
        XCTAssertEqual(v.normalized(), vector(1, 0, 0))
    }

    func testNormalizingVector123() {
        let v = vector(1, 2, 3)
        XCTAssertEqual(v.normalized(), vector(0.26726, 0.53452, 0.80178))
    }

    func testTheMagnitudeOfANormalizedVector() {
        let v = vector(1, 2, 3).normalized()
        XCTAssertEqual(v.magnitude, 1)
    }

}

final class TupleDotProductTests : XCTestCase {

    func testTheDotProductOfTwoTuples() {
        let a = vector(1, 2, 3)
        let b = vector(2, 3, 4)
        XCTAssertEqual(dot(a, b), 20)
    }

}

final class TupleCrossProductTests : XCTestCase {

    func testTheCrossProductOfTwoVectors() {
        let a = vector(1, 2, 3)
        let b = vector(2, 3, 4)
        XCTAssertEqual(cross(a, b), vector(-1, 2, -1))
        XCTAssertEqual(cross(b, a), vector(1, -2, 1))
    }

}
