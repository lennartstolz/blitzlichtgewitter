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
    public func intersect(sphere: Sphere) -> IntersectionResult<Sphere> {
        transformed(by: sphere.transform.inverse)._intersect(sphere: sphere)
    }

    /// Returns the intersection of a ray and a sphere.
    ///
    /// # Implementation Details
    ///
    /// While implementing the `transform` matrix of the sphere, we split the logic of the intersection calculation
    /// into those two methods. The public interface does transform the ray (by the inverse of the sphere's transform
    /// matrix. Afterwards this method is called to caculate the intersections between the modified ray and the sphere.
    ///
    /// This split may be a superfluous indirection but we kept it for now, as the intersection calculation is still
    /// under construction.
    private func _intersect(sphere: Sphere) -> IntersectionResult<Sphere> {
        let sphereToRay = origin - sphere.origin
        let a = dot(direction, direction)
        let b = 2 * dot(direction, sphereToRay)
        let c = dot(sphereToRay, sphereToRay) - 1

        let discriminant = (b*b) - 4 * a * c

        guard discriminant >= 0 else { return .miss }

        let t1 = (-b - sqrt(discriminant)) / (2 * a)
        let t2 = (-b + sqrt(discriminant)) / (2 * a)

        return [Intersection(t: t1, object: sphere), Intersection(t: t2, object: sphere)]
    }

}

// MARK: Transforming Rays

extension Ray {

    /// Returns a new ray that represents the original ray after applying the transformation.
    ///
    /// - Parameters:
    ///     - matrix: The translation applied to the ray.
    ///
    /// - Returns: A new ray that represents the original ray after applying the transformation.
    public func transformed(by matrix: Matrix4x4) -> Ray {
        Ray(origin: matrix * origin, direction:  matrix * direction)
    }

}
