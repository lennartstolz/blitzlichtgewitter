import XCTest
@testable import Blitzlichtgewitter

final class MatrixTests : XCTestCase {

    func testDefaultImplementationOfProtocols() {
        let m = Matrix3x5(rows: [
            [9, 1, 2, 0, 3],
            [0, 0, 2, 3, 1],
            [8, 7, 5, 4, 6],
        ])
        XCTAssertEqual(m[0, 0], 9)
        XCTAssertEqual(m[0, 1], 1)
        XCTAssertEqual(m[0, 2], 2)
        XCTAssertEqual(m[0, 3], 0)
        XCTAssertEqual(m[0, 4], 3)
        XCTAssertEqual(m[1, 0], 0)
        XCTAssertEqual(m[1, 1], 0)
        XCTAssertEqual(m[1, 2], 2)
        XCTAssertEqual(m[1, 3], 3)
        XCTAssertEqual(m[1, 4], 1)
        XCTAssertEqual(m[2, 0], 8)
        XCTAssertEqual(m[2, 1], 7)
        XCTAssertEqual(m[2, 2], 5)
        XCTAssertEqual(m[2, 3], 4)
        XCTAssertEqual(m[2, 4], 6)
    }

}

// MARK: Test Helpers

/// A data structure representing a matrix with three rows and five columns (15 values in total).
///
/// The ray caster solely uses square matrices. Because of that it's easy to screw up some row / column checks which
/// will went unoticed for quite a while because the matrix has the same amout of rows and columns. To ensure the
/// default implementations don't have those row vs. column issues we do use this mxn matrix (where m != n).
private struct Matrix3x5 : Matrix {

    typealias Scalar = Double

    var elements: [Scalar]

}

extension Matrix3x5: _Matrix {

    static let size: Size = (3,5)

}
