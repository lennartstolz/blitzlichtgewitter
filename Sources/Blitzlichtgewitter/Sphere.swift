import Foundation

/// A data structure representing a sphere.
public struct Sphere {

    /// The spheres origin.
    public let origin: Tuple

    /// The spheres radius around the origin.
    public let radius: Double

    /// Creates a sphere geometry with the specified origin and radius.
    ///
    /// - Parameters:
    ///     - origin: The spheres origin.
    ///     - radius: The spheres radius around the origin.
    public init(origin: Tuple, radius: Double) {
        assert(origin.isPoint)
        self.origin = origin
        self.radius = radius
    }

}
