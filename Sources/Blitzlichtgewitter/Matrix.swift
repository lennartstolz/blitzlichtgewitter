import Foundation

/// An interface to describe a grid of numbers (a matrix).
///
/// The ray tracer uses three different matrices: ``Matrix2x2``, ``Matrix3x3`` and ``Matrix4x4``.
/// It almost exclusively uses 4x4 matrices (4 rows and 4 columns).
///
/// Because of that, this protocol solely contains the bare minimum interface to describe a matrix.
/// The API of ``Matrix4x4`` offers additional operations. From a mathematical point of view those operations are also
/// _valid_ for 2x2 and 3x3 matrices, but as there is no use for them in this ray tracer we won't implement them.
///
/// ## Implementation Details
///
/// This protocol and all the data structures conforming to this protocol were mainly build because of the fun creating
/// the ray tracer solely using the Swift programming language without additional (standard) libraries.
///
/// In _real world scenarios_ you should consider using the great `simd` standard library instead. The corresponding
/// data structures of `simd` heavily influenced the API of this protocol and the conforming data structures and their
/// operations. The equivalent of ``Matrix4x4`` is ``simd_double4x4`` (or ``simd_float4x4`` if single-precision values
/// are sufficient).
public protocol Matrix : Equatable {

    /// The type of the numeric values stored in the matrix.
    ///
    /// It's aliased to be able to swap later to a different floating-point precision if needed.
    associatedtype Scalar

    /// Creates a new matrix.
    init()

    /// Creates a new matrix with the specified rows.
    init(rows: [[Scalar]])

    /// Accesses the element at the specified position.
    ///
    /// - Parameters:
    ///     - row:      The vertical (y-axis) position of the element.
    ///     - column:   The horizontal (x-axis) position of the element.
    ///
    /// - Note: The order of parameters differs from the subscript methods of `simd`.
    subscript(row: Int, column: Int) -> Scalar { get set }

}

/// An interface to provide the shared functionality of the matrix data structures.
internal protocol _Matrix : Matrix where Scalar == Double {

    /// Type defining the number of rows and columns of the matrix type.
    /// E.g. a 3x5 matrix consists of three rows with five columns each.
    typealias Size = (rows: Int, columns: Int)

    /// The size of this matrix type.
    static var size: Size { get }

    /// A flat list of elements stored in the matrix.
    ///
    /// The pixel values are stored by rows. E.g. `elements[3]` describes the fourth element (column) of the first row
    /// in a 4x4 matrix, whereas `elements[4]` describes the first element (column) of the second row.
    var elements: [Scalar] { get set }

    /// Creates a new matrix with the specified elements (stored by rows).
    init(elements: [Scalar])

}

// MARK: Creating Matrices

extension _Matrix {

    public init(rows: [[Scalar]]) {
        assert(rows.count == Self.size.rows)
        rows.forEach { assert($0.count == Self.size.columns) }
        self = Self(elements: rows.flatMap { $0 })
    }

    public init() {
        self = Self(elements: .init(repeating: 0, count: Self.size.rows * Self.size.columns))
    }

}

// MARK: Inspecting Matrices

extension _Matrix {

    public subscript(row: Int, column: Int) -> Scalar {
        get {
            elements[row * Self.size.columns + column]
        }
        set {
            elements[row * Self.size.columns + column] = newValue
        }

    }

}

// MARK: Comparing Matrices

extension _Matrix {

    /// Returns a Boolean value indicating whether two matrices are equal.
    ///
    /// Two matrices are equal if all of their elements are equal.
    ///
    /// ## Implementation Details
    ///
    /// Following the pseudocode of [The Ray Tracer Challenge, p. 5](http://raytracerchallenge.com/) we do compare all
    /// elements with a predefined `epsilon` of `0.00001` to avoid having early / hidden inconsistencies with the books
    /// roadmap. Most likely we can either remove or rework this whole concept at a later point in time.
    ///
    /// - Returns: A Boolean value indicating whether two matrices are equal.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        for r in 0..<Self.size.rows {
            for c in 0..<Self.size.rows {
                guard Double.equal(lhs[c, r], rhs[c, r]) else { return false }
            }
        }
        return true
    }

}

fileprivate extension Double {

    /// Returns a Boolean value indicating whether two matrix scalars are equal.
    ///
    /// ## Implementation Details
    ///
    /// Custom implementation of floating-point comparison based on the pseudocode of
    /// [The Ray Tracer Challenge, p. 5](http://raytracerchallenge.com/).
    ///
    /// - Returns: A Boolean value indicating whether two scalars are equal.
    static func equal(_ lhs: Self, _ rhs: Self) -> Bool { abs(lhs - rhs) < 0.00001 }

}

// MARK: Submatrices

/// An interface to provide the shared functionality of the matrices with submatrices (4x4 and 3x3 matrices).
protocol _HasSubmatrices : _Matrix {

    /// The type of the submatrix after removing the row & column.
    /// The submatrix of a 3x3 matrix is a 2x2 matrix.
    associatedtype Submatrix : _Matrix

    /// Returns the resulting matrix after deleting the given row and column.
    ///
    /// - Parameters:
    ///     - row: The row to delete.
    ///     - column: The column to delete.
    ///
    /// - Returns: The resulting matrix after deleting the given row and column
    func submatrix(_ row: Int, _ column: Int) -> Submatrix

}

extension _HasSubmatrices {

    /// The (hidden) _default_ implementation of the protocols' ``submatrix`` method.
    /// - Parameters:
    ///     - row: The row to delete.
    ///     - column: The column to delete.
    ///
    /// - Returns: The resulting matrix after deleting the given row and column
    func _submatrix(_ row: Int, _ column: Int) -> Submatrix {
        // This solution is based on `_Matrix` implementation details, in particular the order in which the values
        // are stored in the `elements` list. If this order changes, we do need to adjust this algorithm, too.
        var elements = [Submatrix.Scalar]()
        for r in 0..<Self.size.rows {
            for c in 0..<Self.size.columns {
                guard r != row && c != column else { continue }
                elements.append(self[r, c])
            }
        }
        return Submatrix(elements: elements)
    }

}
