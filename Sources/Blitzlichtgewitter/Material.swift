import Foundation

/// A data structure representing a "Phong Reflection Model" surface material.
public struct Material {

    /// The material's surface color.
    public var color: Color = .white

    /// The value that manages the material's response to ambient lighting.
    @Clamped(0...1)
    public var ambient: Double = 0.1

    /// The value that manages the material's diffuse response to lighting.
    @Clamped(0...1)
    public var diffuse: Double = 0.9

    /// The value that manages the material's specular response to lighting.
    @Clamped(0...1)
    public var specular: Double = 0.9

    /// The sharpness of specular highlights.
    ///
    /// Although there are no hard bounds for the shininess, this value is clamped between 10 (large highlight) and
    /// 200 (small highlight) for the best render results.
    @Clamped(10...200)
    public var shininess: Double = 200.0

    public init() { }

}

extension Material : Equatable { }


/// A "property wrapper" to define a lower and an upper bound of a floating point value.
///
/// It's based on the `Clamping` property wrapper described in the NSHipster article
/// [Swift Property Wrappers](https://nshipster.com/propertywrapper/).
@propertyWrapper
public struct Clamped<Scalar: FloatingPoint> {

    var value: Scalar

    private let range: ClosedRange<Scalar>

    init(wrappedValue value: Scalar, _ range: ClosedRange<Scalar>) {
        assert(range.contains(value))
        self.value = value
        self.range = range
    }

    public var wrappedValue: Scalar {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }

}

extension Clamped : Equatable { }
