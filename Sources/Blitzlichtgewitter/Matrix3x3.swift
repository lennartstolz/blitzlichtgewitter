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

// MARK: Submatrices

extension Matrix3x3 : _HasSubmatrices {

    /// Returns the resulting matrix after deleting the given row and column.
    ///
    /// - Parameters:
    ///     - row: The row to delete.
    ///     - column: The column to delete.
    ///
    /// - Returns: The resulting matrix after deleting the given row and column
    public func submatrix(_ row: Int, _ column: Int) -> Matrix2x2 { _submatrix(row, column) }

}

// MARK: Minors

extension Matrix3x3 {

    /// Returns the minor (the determinant of the submatrix at the given `row` and `column`).
    ///
    /// - Parameters
    ///     - row: The row of the submatrix to determine the minor.
    ///     - column: The column of the submatrix to determine the minor.
    ///
    /// - Returns: he minor (the determinant of the submatrix at at `row`/`column`).
    public func minor(_ row: Int, _ column: Int) -> Scalar {
        submatrix(row, column).determinant
    }

}
