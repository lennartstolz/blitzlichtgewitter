import Foundation

/// A data structure representing the intersection of a ray and an object.
///
/// ## Implementation Details
///
/// This abstraction may be over-engineered and superfluous because maybe an optional type could do the job as well.
public enum Intersection {
    /// The ray didn't hit the object (e.g. the ``Sphere``).
    case miss
    /// The ray hit the object for the given "time" value.
    ///
    /// This case will always return two intersections. In case the ray only tangents a surface (which results only in
    /// one intersection) this case will provide the same value twice. This helps to determine object overlaps.
    case intersection(_ t1: Double, _ t2: Double)
}

extension Intersection : Equatable { }
