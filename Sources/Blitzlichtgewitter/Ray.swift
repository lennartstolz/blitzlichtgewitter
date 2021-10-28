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
