import Foundation

/// A data structure representing a light source.
///
/// A point light is describes a light source with no size at a single position in space.
public struct PointLight {

    /// The lights' position in world space.
    public let position: Tuple

    /// The brightness and the chromaticity of the point light.
    public let intensity: Color

    /// Creates a new ppint light source.
    ///
    /// - Parameters:
    ///     - position: The lights' position in world space.
    ///     - intensity: The brightness and the chromaticity of the point light.
    public init(position: Tuple, intensity: Color) {
        assert(position.isPoint)
        self.position = position
        self.intensity = intensity
    }

}
