import Foundation

/// A data structure representing a ray
///
/// A ray has a starting point (the ``origin``) and a vector called the ``direction`` to describe where it points.
public struct Ray {

    /// The start point from which the ray is cast.
    public let origin: Tuple

    // The direction the ray points to.
    public let direction: Tuple

    /// Creates a new ray.
    ///
    /// - Parameters:
    ///     - origin: The start point from which the ray is cast.
    ///     - direction: The direction the ray points to.
    public init(origin: Tuple, direction: Tuple) {
        assert(origin.isPoint)
        assert(direction.isVector)
        self.origin = origin
        self.direction = direction
    }

}

extension Ray {

    /// Returns the position of the ray at a given time.
    ///
    /// - Parameters:
    ///     - time: The "time" the ray had to travel (if you think about the direction vector as "speed").
    ///
    /// - Returns: The position of the ray at the given time.
    public func position(at time: Double) -> Tuple {
        origin + direction * time
    }

}

// MARK: Intersecting Rays with Spheres

extension Ray {

    /// Returns the intersection of a ray and a sphere.
    ///
    /// - Parameters:
    ///     - sphere: The sphere to calculate the intersection.
    ///
    /// - Returns: The intersection points of a ray and a sphere.
    public func intersect(sphere: Sphere) -> Intersection {

        let sphereToRay = origin - sphere.origin
        let a = dot(direction, direction)
        let b = 2 * dot(direction, sphereToRay)
        let c = dot(sphereToRay, sphereToRay) - 1

        let discriminant = (b*b) - 4 * a * c

        guard discriminant >= 0 else { return .miss }

        let t1 = (-b - sqrt(discriminant)) / (2 * a)
        let t2 = (-b + sqrt(discriminant)) / (2 * a)

        return .intersection(t1, t2)
    }

}
