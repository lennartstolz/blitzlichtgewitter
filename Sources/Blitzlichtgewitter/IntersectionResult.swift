import Foundation

/// The result type of a ray intersecting an object.
///
/// ## Implementation Details
///
/// [The Ray Tracer Challenge](http://raytracerchallenge.com/) returns ray-object intersections as a list of elements.
/// Most likely, the author choose this API for the sake of simplicity. But this comes with a lot of implicit
/// assumptions (e.g. an intersection of a  ray and a sphere either has 0 or two intersections) which aren't baked to
/// the type system.
///
/// To be inline with the API described in the book (at least during the implementation of the ray tracers basic feature
/// set) we are using an array here as well. Nevertheless, we "typealiased" this type already, to be able to migrate it
/// to a more sophisticated type at a later point in time.
public typealias IntersectionResult<Object> = Array<Intersection<Object>>

extension IntersectionResult {

    /// The intersection result if the ray didn't hit the object.
    static var miss : Self { [] }

}

/// Aggregate a list of intersections to a _single_ intersection result object.
public func intersections<Object>(_ i: Intersection<Object>...) -> IntersectionResult<Object> { i }

/// Aggregate a list of intersection results to a _single_ intersection result object.
public func intersections<Object>(_ i: IntersectionResult<Object>...) -> IntersectionResult<Object> { i.reduce([], +) }

/// Identifies and returns the hit from the given intersection results.
///
/// - Parameters:
///     - intersections: A list of intersection records.
///
/// - Returns: The intersection with the lowest nonnegative t value.
public func hit<Object>(_ intersections: IntersectionResult<Object>) -> Intersection<Object>? {
    intersections
        .filter({ $0.t >= 0 })
        .sorted(by: { $0.t < $1.t })
        .first
}
