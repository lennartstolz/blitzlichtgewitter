import Foundation

/// A data structure representing a matrix with two rows and two columns (4 values in total).
public struct Matrix2x2 : Matrix {

    /// The type of the numeric values stored in the matrix.
    public typealias Scalar = Double

    /// A flat list of elements stored in the matrix.
    var elements: [Scalar]

}

extension Matrix2x2 : _Matrix {

    static let size: Size = (2,2)

}

// MARK: Determinants

extension Matrix2x2 {

    /// The determinant of the matrix.
    ///
    /// The determinant is a number that is derived from the elements of a matrix. The name comes from the use of
    /// matrices to solve systems of equations, where it's used to _determine_ whether or not the system has a solution.
    /// If the determinant is zero, then the corresponding system of equations has no solution.
    ///
    /// [The Ray Tracer Challenge pp. 34](http://raytracerchallenge.com/)
    public var determinant: Scalar {
        self[0, 0] * self[1, 1] - self[0, 1] * self[1, 0]
    }

}
