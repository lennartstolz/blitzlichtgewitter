import Foundation

/// A data structure representing points and vectors in three-dimensional space.
///
/// Use one of the following factory methods to instantiate a `Tuple`:
///
/// 1) ``tuple(_:_:_:_:)`` to instantiate a custom tuple type.
/// 2) ``point(_:_:_:)`` to instantiate a tuple representing a point (w = 1.0).
/// 3) ``vector(_:_:_:)`` to instantiate a tuple representing a vector (w = 0.0).
///
/// ## Implementation Details
///
/// This type does not follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
/// and will be refactored at a late point in time. But for now, I built it this way to be very close to the test
/// scenarios of [The Ray Tracer Challenge](http://raytracerchallenge.com/) by Jamis Buck.
///
/// Several operations, e.g. ``+(lhs:rhs:)`` and ``-(lhs:rhs:)``, are only defined for _special_ combinations of vectors
/// and points and we do have assertions at the moment to raise issues when they are called with an unsupported
/// combination of points and vectors. This could be improved by leveraging the type system not to offer these
/// operations in the first place, if they aren't supported.
public struct Tuple {

    /// The type of the scalar used for the ``x``, ``y``, ``z`` and ``w`` elements of the vector.
    ///
    /// It's aliased to be able to swap later to a different floating-point precision and/or as a preparation to make
    /// this type generic to support different floating-point precisions if needed.
    public typealias Scalar = Double

    /// The first element of the tuple.
    public let x: Scalar

    /// The second element of the tuple.
    public let y: Scalar

    /// The third element of the tuple.
    public let z: Scalar

    /// The fourth element of the tuple.
    public let w: Scalar

    /// Creates a new tuple from the given elements.
    ///
    /// - Parameters:
    ///     - x: The first element of the tuple.
    ///     - y: The second element of the tuple.
    ///     - z: The third element of the tuple.
    ///     - w: The fourth element of the tuple.
    init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

}

public extension Tuple {

    /// A Boolean value indicating whether the instance is a point.
    var isPoint: Bool { w == 1.0 }

    /// A Boolean value indicating whether the instance is a vector.
    var isVector: Bool { w == 0.0 }

}

/// Creates a new tuple from the given elements.
///
/// - Parameters:
///     - x: The first element of the tuple.
///     - y: The second element of the tuple.
///     - z: The third element of the tuple.
///     - w: The fourth element of the tuple.
///
/// - Returns: A new tuple created from the given elements.
public func tuple(_ x: Tuple.Scalar, _ y: Tuple.Scalar, _ z: Tuple.Scalar, _ w: Tuple.Scalar) -> Tuple {
    Tuple(x: x, y: y, z: z, w: w)
}

/// Creates a new point from the given elements.
///
/// - Parameters:
///     - x: The first element of the point.
///     - y: The second element of the point.
///     - z: The third element of the point.
///
/// - Returns: A new tuple created from the given elements.
public func point(_ x: Tuple.Scalar, _ y: Tuple.Scalar, _ z: Tuple.Scalar) -> Tuple {
    Tuple(x: x, y: y, z: z, w: 1.0)
}

/// Creates a new vector from the given elements.
///
/// - Parameters:
///     - x: The first element of the vector.
///     - y: The second element of the vector.
///     - z: The third element of the vector.
///
/// - Returns: A new tuple created from the given elements.
public func vector(_ x: Tuple.Scalar, _ y: Tuple.Scalar, _ z: Tuple.Scalar) -> Tuple {
    Tuple(x: x, y: y, z: z, w: 0.0)
}

// MARK: - Operations

// MARK: Comparing Tuples

extension Tuple : Equatable {

    /// Returns a Boolean value indicating whether two tuples are equal.
    ///
    /// Two tuples are equal if all of their elements are equal.
    ///
    /// ## Implementation Details
    ///
    /// Following the pseudocode of [The Ray Tracer Challenge, p. 5](http://raytracerchallenge.com/) we do compare all
    /// elements with a predefined `epsilon` of `0.00001` to avoid having early / hidden inconsistencies with the books
    /// roadmap. Most likely we can either remove or rework this whole concept at a later point in time.
    ///
    /// - Returns: A Boolean value indicating whether two tuples are equal.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        Scalar.equal(lhs.x, rhs.x) &&
        Scalar.equal(lhs.y, rhs.y) &&
        Scalar.equal(lhs.z, rhs.z) &&
        Scalar.equal(lhs.w, rhs.w)
    }

}

private extension Tuple.Scalar {

    /// Returns a Boolean value indicating whether two scalars are equal.
    ///
    /// ## Implementation Details
    ///
    /// Custom implementation of floating-point comparison based on the pseudocode of
    /// [The Ray Tracer Challenge, p. 5](http://raytracerchallenge.com/).
    ///
    /// - Returns: A Boolean value indicating whether two scalars are equal.
    static func equal(_ lhs: Self, _ rhs: Self) -> Bool { abs(lhs - rhs) < 0.00001 }

}

// MARK: Adding Tuples

extension Tuple {

    /// Adds two tuples and produces their sum, rounded to a representable value.
    ///
    /// - Parameters:
    ///     - lhs: The first value to add.
    ///     - rhs: The second value to add.
    ///
    /// - Returns: The sum of two tuples.
    public static func + (lhs: Self, rhs: Self) -> Self {
        assert(lhs.w + rhs.w != 2, "Adding two points is an invalid operation.")
        return Tuple(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
    }

}

// MARK: Subtracting Tuples

extension Tuple {

    /// Subtracts one tuple from another and produces their difference, rounded to a representable value.
    ///
    /// - Parameters:
    ///  - lhs: The first value to calculate the difference.
    ///  - rhs: The tuple to subtract from lhs.
    ///
    /// - Returns: The result of substracting rhs from lhs.
    public static func - (lhs: Self, rhs: Self) -> Self {
        assert(lhs.w - rhs.w >= 0, "Substracting a point from a vector is an invalid operation.")
        return Tuple(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
    }

}

// MARK: Negating Tuples

extension Tuple {

    /// A tuple with zero in all lanes.
    public static let zero: Self = Self(x: 0.0, y: 0.0, z: 0.0, w: 0.0)

    /// Returns the _oppositve_ of the given vector.
    ///
    /// - Parameters:
    ///     - t: The tuple which should be negated.
    ///
    /// - Returns: The negation of the given vector.
    public static prefix func - (t: Self) -> Self { tuple(-t.x, -t.y, -t.z, -t.w) }

}

// MARK: Scalar Multiplication

extension Tuple {

    /// Multiplies a tuple by a scalar and produces their product, rounding to a representable value.
    ///
    /// - Parameters:
    ///     - t: The tuple to multiply be the scalar.
    ///     - s: The scalar to calculate the product with the tuple.
    ///
    /// - Returns: The product of the tuple multiplied with the scalar.
    public static func * (t: Self, s: Self.Scalar) -> Self { Self(x: t.x * s, y: t.y * s, z: t.z * s, w: t.w * s) }

}

// MARK: Scalar Division

extension Tuple {

    /// Returns the quotient of dividing the tuple by the scalar, rounded to a representable value.
    ///
    /// - Parameters:
    ///     - t: The tuple to divide.
    ///     - s: The value to divide lhs by.
    ///
    /// - Returns: The quotient of dividing the tuple by the scalar, rounded to a representable value.
    public static func / (t: Self, s: Self.Scalar) -> Self { Self(x: t.x / s, y: t.y / s, z: t.z / s, w: t.w / s) }

}

// MARK: Magnitude / Length

extension Tuple {

    /// Returns the length of a vector.
    public var magnitude: Self.Scalar {
        sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2) + pow(w, 2)) // Pythagoras' theorem
    }

}

// MARK: Normalization

extension Tuple {

    /// Returns a vector pointing in the same direction of the supplied vector with a length of 1.
    ///
    /// Normalization is the process of taking an arbitrary vector and converting it into a unit vector.
    ///
    /// - Returns: A vector pointing in the same direction of the supplied vector with a length of 1.
    public func normalized() -> Self {
        let magnitude = self.magnitude
        assert(magnitude != 0, "Normalizing a vector with a magnitude of 0 is an invalid operation.")
        return Self(x: x / magnitude, y: y / magnitude, z: z / magnitude, w: w / magnitude)
    }

}

// MARK: Dot Product

/// Returns the dot product of two tuples.
///
/// - Returns: The dot product of two tuples.
public func dot(_ lhs: Tuple, _ rhs: Tuple) -> Tuple.Scalar {
    lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z + lhs.w * rhs.w
}

// MARK: Cross Product

/// Returns the cross product of two tuples.
///
/// - Returns: The cross product of two tuples.
public func cross(_ lhs: Tuple, _ rhs: Tuple) -> Tuple {
    assert(lhs.isVector && rhs.isVector, "The cross product is only implemented for vectors.")
    return vector(lhs.y * rhs.z - lhs.z * rhs.y,
                  lhs.z * rhs.x - lhs.x * rhs.z,
                  lhs.x * rhs.y - lhs.y * rhs.x)
}

// MARK: Reflecting Vectors

/// Returns the reflection direction of an incident vector and a normal vector.
///
/// - Returns: The reflection direction of an incident vector and a normal vector.
public func reflect(_ vector: Tuple, _ normal: Tuple) -> Tuple {
    assert(vector.isVector)
    assert(normal.isVector)
    return vector - normal * 2 * dot(vector, normal)
}
