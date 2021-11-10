import Foundation

/// A data structure representing a sphere.
public struct Sphere {

    /// The spheres origin.
    public let origin: Tuple

    /// The spheres radius around the origin.
    public let radius: Double

    /// The transform applied to sphere.
    public var transform: Matrix4x4

    /// Creates a sphere geometry with the specified origin and radius.
    ///
    /// - Parameters:
    ///     - origin: The spheres origin.
    ///     - radius: The spheres radius around the origin.
    ///     - transform: The transform applied to sphere.
    public init(origin: Tuple, radius: Double, transform: Matrix4x4 = .identity) {
        assert(origin.isPoint)
        self.origin = origin
        self.radius = radius
        self.transform = transform
    }

}

extension Sphere : Equatable { }
