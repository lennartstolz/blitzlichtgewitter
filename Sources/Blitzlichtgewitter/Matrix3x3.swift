import Foundation

/// A data structure representing a matrix with three rows and three columns (9 values in total).
public struct Matrix3x3 : Matrix {

    /// The type of the numeric values stored in the matrix.
    public typealias Scalar = Double

    /// A flat list of elements stored in the matrix.
    var elements: [Scalar]

}

extension Matrix3x3 : _Matrix {

    static let size: Size = (3,3)

}
