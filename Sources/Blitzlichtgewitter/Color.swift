import Foundation

/// A data structure representing a color as a composite of three colors: ``red``, ``green`` and ``blue``.
///
/// This data structure is primarily a specialization of ``Tuple`` to provide descriptive property names. Both types
/// share the majority of operations and need to be interchangeable. Because of that, it likely needs some rework and
/// generalization in the future.
public struct Color {

    public typealias ColorDepth = Double

    /// The red component of the color.
    public let red: ColorDepth

    /// The green component of the color.
    public let green: ColorDepth

    /// The blue component of the color.
    public let blue: ColorDepth

    /// Creates a new color from the given components.
    ///
    /// - Parameters
    ///     - red: The red component of the color.
    ///     - green: The green component of the color.
    ///     - blue: The blue component of the color.
    public init(red: ColorDepth, green: ColorDepth, blue: ColorDepth) {
        self.red = red
        self.green = green
        self.blue = blue
    }

}

extension Color : ExpressibleByArrayLiteral {

    public typealias ArrayLiteralElement = Self.ColorDepth

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        assert(elements.count == 3, "A color consists of three elements")
        self.init(red: elements[0], green: elements[1], blue: elements[2])
    }

}

// MARK: - Operations

// MARK: Comparing Colors

extension Color : Equatable {

    /// Returns a Boolean value indicating whether two colors are equal.
    ///
    /// Two colors are equal if all of their components are equal.
    ///
    /// ## Implementation Details
    ///
    /// Following the pseudocode of [The Ray Tracer Challenge, p. 5](http://raytracerchallenge.com/) we do compare all
    /// elements with a predefined `epsilon` of `0.00001` to avoid having early / hidden inconsistencies with the books
    /// roadmap. Most likely, we can either remove or rework this whole concept at a later point in time.
    ///
    /// - Returns: A Boolean value indicating whether two colors are equal.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        ColorDepth.equal(lhs.red, rhs.red) &&
        ColorDepth.equal(lhs.green, rhs.green) &&
        ColorDepth.equal(lhs.blue, rhs.blue)
    }

}

private extension Color.ColorDepth {

    /// Returns a Boolean value indicating whether two color depth values are equal.
    ///
    /// ## Implementation Details
    ///
    /// Custom implementation of floating-point comparison based on the pseudocode of
    /// [The Ray Tracer Challenge, p. 5](http://raytracerchallenge.com/).
    ///
    /// - Returns: A Boolean value indicating whether two color depth values are equal.
    static func equal(_ lhs: Self, _ rhs: Self) -> Bool { abs(lhs - rhs) < 0.00001 }

}

// MARK: Adding Colors

extension Color {

    /// Adds two colors and produces their sum, rounded to a representable value.
    ///
    /// - Parameters:
    ///     - lhs: The first value to add.
    ///     - rhs: The second value to add.
    ///
    /// - Returns: The sum of two colors.
    public static func + (lhs: Self, rhs: Self) -> Self {
        [lhs.red + rhs.red, lhs.green + rhs.green, lhs.blue + rhs.blue]
    }

}

// MARK: Subtracting Colors

extension Color {

    /// Subtracts one color from another and produces their difference, rounded to a representable value.
    ///
    /// - Parameters:
    ///  - lhs: The first value to calculate the difference.
    ///  - rhs: The color to subtract from lhs.
    ///
    /// - Returns: The result of substracting rhs from lhs.
    public static func - (lhs: Self, rhs: Self) -> Self {
        [lhs.red - rhs.red, lhs.green - rhs.green, lhs.blue - rhs.blue]
    }

}

// MARK: Scalar Multiplication

extension Color {

    /// Multiplies a color by a scalar and produces their product, rounding to a representable value.
    ///
    /// - Parameters:
    ///     - c: The color to multiply be the scalar.
    ///     - s: The scalar to calculate the product with the color.
    ///
    /// - Returns: The product of the color multiplied with the scalar.
    public static func * (c: Self, s: Self.ColorDepth) -> Self {
        [c.red * s, c.green * s, c.blue * s]
    }

}

// MARK: Color Multiplication

extension Color {

    /// Multiplies two colors and produces their product, rounding to a representable value.
    ///
    /// The multiplication blends the two colors. This method of mixing two colors is called
    /// [Hadamard Product](https://en.wikipedia.org/wiki/Hadamard_product_(matrices)) .
    ///
    /// - Parameters:
    ///     - lhs: The first value to multiply.
    ///     - rhs: The second value to multiply.
    ///
    /// - Returns: The product of two colors.
    public static func * (lhs: Self, rhs: Self) -> Self {
        [lhs.red * rhs.red, lhs.green * rhs.green, lhs.blue * rhs.blue]
    }

}
