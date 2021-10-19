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
