import Foundation

/// A data structure representing a matrix with four rows and four columns (16 values in total).
///
/// This data structure is the most important matrix type of the ray caster. Because of that, it offers plenty methods
/// and operations which aren't implement on any other matrix type.
public struct Matrix4x4 : Matrix {

    /// The type of the numeric values stored in the matrix.
    public typealias Scalar = Double

    /// A flat list of elements stored in the matrix.
    var elements: [Scalar]

}

extension Matrix4x4 : _Matrix {

    static let size: Size = (4,4)

}

// MARK: Multiplying Matrices

extension Matrix4x4 {

    /// Multiplies a two matrices and produces their product, rounding to a representable value.
    ///
    /// A matrix multiplication computes the dot product of every row-column combination.
    ///
    /// - Parameters:
    ///     - lhs: The first matrix to multiply.
    ///     - rhs: The second matrix to multiply.
    ///
    /// - Returns: The product of the matrices multiplied.
    public static func * (lhs: Self, rhs: Self) -> Self {
        var res = Matrix4x4()
        for r in 0..<4 {
            for c in 0..<4 {
                let row = tuple(lhs[r, 0], lhs[r, 1], lhs[r, 2], lhs[r, 3])
                let column = tuple(rhs[0, c], rhs[1, c], rhs[2, c], rhs[3, c])
                res[r, c] = dot(row, column)
            }
        }
        return res
    }

}

extension Matrix4x4 {

    /// Multiplies a matrix by a tuple and produces their product, rounding to a representable value.
    ///
    /// - Parameters:
    ///     - m: The matrix to multiply be the tuple.
    ///     - s: The tuple to calculate the product with the matrix.
    ///
    /// - Returns: The product of the matrix multiplied with the tuple.
    public static func * (m: Self, t: Tuple) -> Tuple {
        // Using an array of length 4 is a shady shortcut to obfuscate the lack of a proper subscript API of `Tuple`.
        // As the API of all basic types of this ray tracer will evolve rapidly in the upcoming weeks and month we will
        // also revist this use case to provide a better fitting API for accessing the values without using the
        // `Tuple.{x,y,z,w}` notation.
        var res = [Tuple.Scalar](repeating: 0, count: 4)
        for r in 0..<4 {
            let row = tuple(m[r, 0], m[r, 1], m[r, 2], m[r, 3])
            res[r] = dot(row, t)
        }
        return tuple(res[0], res[1], res[2], res[3])
    }

}

// MARK: Identity Matrix

extension Matrix4x4 {

    /// A 4x4 identity matrix.
    public static let identity = Self(rows:[
        [ 1,  0,  0,  0 ],
        [ 0,  1,  0,  0 ],
        [ 0,  0,  1,  0 ],
        [ 0,  0,  0,  1 ],
    ])

}

// MARK: Transposing Matrices

extension Matrix4x4 {

    /// Returns a matrix transposed to the supplied matrix.
    ///
    /// When you transpose a matrix the rows become columns and the columns become rows.
    ///
    /// - Returns: A matrix transposed to the supplied matrix.
    public func transposed() -> Self {
        var r: Self = Self(elements: self.elements)
        r.transpose()
        return r
    }

    /// Transposes the matrix in place.
    ///
    /// When you transpose a matrix the rows become columns and the columns become rows.
    public mutating func transpose() {
        let m = self
        self[0, 0] = m[0, 0]
        self[0, 1] = m[1, 0]
        self[0, 2] = m[2, 0]
        self[0, 3] = m[3, 0]
        self[1, 0] = m[0, 1]
        self[1, 1] = m[1, 1]
        self[1, 2] = m[2, 1]
        self[1, 3] = m[3, 1]
        self[2, 0] = m[0, 2]
        self[2, 1] = m[1, 2]
        self[2, 2] = m[2, 2]
        self[2, 3] = m[3, 2]
        self[3, 0] = m[0, 3]
        self[3, 1] = m[1, 3]
        self[3, 2] = m[2, 3]
        self[3, 3] = m[3, 3]
    }

}
