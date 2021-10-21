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
    /// - Parameters:
    ///     - row: The row of the submatrix to determine the minor.
    ///     - column: The column of the submatrix to determine the minor.
    ///
    /// - Returns: he minor (the determinant of the submatrix at at `row`/`column`).
    public func minor(_ row: Int, _ column: Int) -> Scalar {
        submatrix(row, column).determinant
    }

}

// MARK: Cofactors

extension Matrix3x3 {


    /// Returns the cofactor of the given row and column.
    ///
    /// - Parameters:
    ///     - row: The row to determine the cofactor.
    ///     - column: The column determine the cofactor.
    ///
    /// The cofactor of the matrix is a (potentially) negated minor of the 3x3 matrix.
    /// It is negated for all (`row`/`column`) combinations where their element in the given matrix is `-`.
    ///
    /// ```
    /// [ +  -  + ]
    /// [ -  +  - ]
    /// [ +  -  + ]
    /// ```
    ///
    /// - Returns the cofactor of the given row and column.
    public func cofactor(_ row: Int, _ column: Int) -> Scalar {
        let minor = minor(row, column)
        return (row + column).isOdd ? -minor : minor
    }

}

private extension Int {

    /// Returns true if the value represents an odd number.
    var isOdd : Bool { !isEven }

    /// Returns true if the value represents an even number.
    var isEven : Bool { self % 2 == 0 }

}
