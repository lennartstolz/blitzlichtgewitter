import Foundation

/// A data structure representing a sphere.
public struct Sphere {

    /// The spheres origin.
    public let origin: Tuple

    /// The spheres radius around the origin.
    public let radius: Double

    /// The transform applied to sphere.
    public var transform: Matrix4x4

    /// The spheres' material that determines its appearance when rendered.
    public var material: Material

    /// Creates a sphere geometry with the specified origin and radius.
    ///
    /// - Parameters:
    ///     - origin: The spheres origin.
    ///     - radius: The spheres radius around the origin.
    ///     - transform: The transform applied to sphere.
    ///     - material: The spheres' material that determines its appearance when rendered.
    public init(origin: Tuple,
                radius: Double,
                transform: Matrix4x4 = .identity,
                material: Material = Material()) {
        assert(origin.isPoint)
        self.origin = origin
        self.radius = radius
        self.transform = transform
        self.material = material
    }

}

extension Sphere : Equatable { }

// MARK: Surface Normal

extension Sphere {

    /// Returns the (surface) normal at the given point.
    ///
    /// A _surface normal_ (or just _normal_) is a vector that points perpendicular to a surface at a given point.
    /// [The Ray Tracer Challenge, p. 76](http://raytracerchallenge.com/).
    ///
    /// - Returns: The (surface) normal at the given point.
    public func normal(at worldPoint: Tuple) -> Tuple {
        assert(worldPoint.isPoint)
        let objectPoint = self.transform.inverse * worldPoint
        let objectNormal = objectPoint - point(0, 0, 0)
        var worldNormal = self.transform.inverse.transposed() * objectNormal
        worldNormal = tuple(worldNormal.x, worldNormal.y, worldNormal.z, 0)
        return worldNormal.normalized()
    }

}

// MARK: Unit Sphere

extension Sphere {

    /// A unit sphere (radius 1) originated at the worlds' origin.
    public static var unit : Self { Self(origin: point(0, 0, 0), radius: 1) }

}
