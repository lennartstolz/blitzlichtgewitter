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
        (0...3).forEach { r in
            (0...3).forEach { c in
                self[r, c] = m[c, r]
            }
        }
    }

}

// MARK: Submatrices

extension Matrix4x4 : _HasSubmatrices {

    /// Returns the resulting matrix after deleting the given row and column.
    ///
    /// - Parameters:
    ///     - row: The row to delete.
    ///     - column: The column to delete.
    ///
    /// - Returns: The resulting matrix after deleting the given row and column
    public func submatrix(_ row: Int, _ column: Int) -> Matrix3x3 { _submatrix(row, column) }

}

// MARK: Minors

extension Matrix4x4 {

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

extension Matrix4x4 {

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
    /// [ +  -  + - ]
    /// [ +  -  + - ]
    /// [ +  -  + - ]
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

// MARK: Determinants

extension Matrix4x4 {

    /// The determinant of the matrix.
    ///
    /// The determinant is a number that is derived from the elements of a matrix. The name comes from the use of
    /// matrices to solve systems of equations, where it's used to _determine_ whether or not the system has a solution.
    /// If the determinant is zero, then the corresponding system of equations has no solution.
    ///
    /// [The Ray Tracer Challenge pp. 34](http://raytracerchallenge.com/)
    public var determinant : Scalar {
        var det: Scalar = 0
        for c in 0..<4 {
            det += self[0, c] * cofactor(0, c)
        }
        return det
    }

}

// MARK: Inversion

extension Matrix4x4 {

    /// A Boolean value indicating whether the instance is invertible.
    ///
    /// If the determinant is 0, the matrix is not invertible.
    public var isInvertible : Bool {  determinant != 0 }

    /// The inverse of the matrix.
    public var inverse : Matrix4x4 {
        var m: Self = Self(elements: elements)
        m.invert()
        return m
    }

    /// Replaces the receiver’s matrix with its inverse matrix.
    public mutating func invert() {
        let original = self
        let determinant = self.determinant
        for row in 0..<4 {
            for column in 0..<4 {
                // `[column, row]` perform a `transpose` operation "in-place".
                self[column, row] = original.cofactor(row, column) / determinant
            }
        }

    }

}

// MARK: Translation

/// Translation is a transformation that moves a point.
///
/// - Parameters:
///     - x: The translation of the vectors' `x` element.
///     - x: The translation of the vectors' `y` element.
///     - x: The translation of the vectors' `z` element.
///
/// - Returns: A translation matrix to perform a transformation to move a point.
public func translation(_ x: Matrix4x4.Scalar,
                        _ y: Matrix4x4.Scalar,
                        _ z: Matrix4x4.Scalar) -> Matrix4x4 {
    Matrix4x4(rows: [
        [ 1,  0,  0,  x ],
        [ 0,  1,  0,  y ],
        [ 0,  0,  1,  z ],
        [ 0,  0,  0,  1 ],
    ])
}

// MARK: Scaling

/// Scaling is a transformation that moves a point by multiplication.
///
/// - Parameters:
///     - x: The translation of the vectors' `x` element.
///     - x: The translation of the vectors' `y` element.
///     - x: The translation of the vectors' `z` element.
///
/// - Returns: A translation matrix to perform a transformation to scale a point.
public func scaling(_ x: Matrix4x4.Scalar,
                    _ y: Matrix4x4.Scalar,
                    _ z: Matrix4x4.Scalar) -> Matrix4x4 {
    Matrix4x4(rows: [
        [ x,  0,  0,  0 ],
        [ 0,  y,  0,  0 ],
        [ 0,  0,  z,  0 ],
        [ 0,  0,  0,  1 ],
    ])
}

// MARK: Rotation

/// Multiplying a tuple by this rotation matrix will rotate that tuple around the x-axis.
///
/// - Parameters:
///     - rad: The radians to rotate around the x-axis.
///
/// - Returns: A rotation matrix to perform the rotation transformation around the x-axis.
public func rotation_x(rad r: Matrix4x4.Scalar) -> Matrix4x4 {
    Matrix4x4(rows: [
        [       1,           0,           0,           0       ],
        [       0,      cos(r),     -sin(r),           0       ],
        [       0,      sin(r),      cos(r),           0       ],
        [       0,           0,           0,           1       ],
    ])
}

/// Multiplying a tuple by this rotation matrix will rotate that tuple around the x-axis.
///
/// - Parameters:
///     - deg: The degrees to rotate around the x-axis.
///
/// - Returns: A rotation matrix to perform the rotation transformation around the x-axis.
public func rotation_x(deg: Matrix4x4.Scalar) -> Matrix4x4 { rotation_x(rad: radians(deg: deg)) }

/// Multiplying a tuple by this rotation matrix will rotate that tuple around the y-axis.
///
/// - Parameters:
///     - rad: The radians to rotate around the y-axis.
///
/// - Returns: A rotation matrix to perform the rotation transformation around the y-axis.
public func rotation_y(rad r: Matrix4x4.Scalar) -> Matrix4x4 {
    Matrix4x4(rows: [
        [  cos(r),           0,      sin(r),           0       ],
        [       0,           1,           0,           0       ],
        [ -sin(r),           0,      cos(r),           0       ],
        [       0,           0,           0,           1       ],
    ])
}

/// Multiplying a tuple by this rotation matrix will rotate that tuple around the y-axis.
///
/// - Parameters:
///     - deg: The degrees to rotate around the y-axis.
///
/// - Returns: A rotation matrix to perform the rotation transformation around the y-axis.
public func rotation_y(deg: Matrix4x4.Scalar) -> Matrix4x4 { rotation_y(rad: radians(deg: deg)) }

/// Multiplying a tuple by this rotation matrix will rotate that tuple around the z-axis.
///
/// - Parameters:
///     - deg: The degrees to rotate around the z-axis.
///
/// - Returns: A rotation matrix to perform the rotation transformation around the z-axis.
public func rotation_z(rad r: Matrix4x4.Scalar) -> Matrix4x4 {
    Matrix4x4(rows: [
        [  cos(r),     -sin(r),           0,           0       ],
        [  sin(r),      cos(r),           0,           0       ],
        [       0,           0,           1,           0       ],
        [       0,           0,           0,           1       ],
    ])
}

/// Multiplying a tuple by this rotation matrix will rotate that tuple around the z-axis.
///
/// - Parameters:
///     - deg: The degrees to rotate around the z-axis.
///
/// - Returns: A rotation matrix to perform the rotation transformation around the z-axis.
public func rotation_z(deg: Matrix4x4.Scalar) -> Matrix4x4 { rotation_z(rad: radians(deg: deg)) }

/// Transforms the given degrees into a radian value (to be used for rotation transformations.
private func radians(deg: Matrix4x4.Scalar) -> Matrix4x4.Scalar { (deg / 180) * .pi }

// MARK: Shearing

/// Returns a shearing (skew) transformation matrix.
///
/// A shearing (or skew) transformation has the effect of making straight lines slanted.
///
///[The Ray Tracer Challenge pp. 51](http://raytracerchallenge.com/)
///
/// - Parameters:
///     - xy: Define the shear transformation of x in proportion to y
///     - xz: Define the shear transformation of x in proportion to z
///     - yx: Define the shear transformation of y in proportion to x
///     - yz: Define the shear transformation of y in proportion to z
///     - zx: Define the shear transformation of z in proportion to x
///     - zy: Define the shear transformation of y in proportion to y
///
/// - Returns: A shearing (skew) transformation matrix.
public func shearing(_ xy: Matrix4x4.Scalar,
                     _ xz: Matrix4x4.Scalar,
                     _ yx: Matrix4x4.Scalar,
                     _ yz: Matrix4x4.Scalar,
                     _ zx: Matrix4x4.Scalar,
                     _ zy: Matrix4x4.Scalar) -> Matrix4x4 {
    Matrix4x4(rows: [
        [  1,  xy,  xz,   0  ],
        [ yx,   1,  yz,   0  ],
        [ zx,  zy,   1,   0  ],
        [ 0,    0,   0,   1  ],
    ])
}
