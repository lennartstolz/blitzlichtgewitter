import Foundation

/// A data structure representing the intersection of a ray and an object.
public struct Intersection<Object> {

    /// The time value when the ray hits the object.
    public let t: Double

    /// The object hit by the ray at the given time value.
    public let object: Object

    /// Creates a new intersection.
    ///
    /// - Parameters:
    ///     - t: The time value when the ray hits the object.
    ///     - object: The object hit by the ray at the given time value.
    public init(t: Double, object: Object) {
        self.t = t
        self.object = object
    }

}

extension Intersection : Equatable where Object : Equatable { }
