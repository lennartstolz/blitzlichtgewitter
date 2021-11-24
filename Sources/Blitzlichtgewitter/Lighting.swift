import Foundation

/// Calculates the "Phong Shading" of an object in three-dimensional-space (for the given point).
///
/// - Parameters:
///     - material: The surface material lit.
///     - light: The point light source lighting the "scenery".
///     - point: The point being illuminated.
///     - eyeVector: The eye vector for applying the phong reflection model.
///     - normalVector: The normal vector for applying the phong reflection model.
///
/// - Returns: The color of `point` when rendering the "scenery" with the phong reflection model.
public func lighting(
    _ material: Material,
    _ light: PointLight,
    _ point: Tuple,
    _ eyeVector: Tuple,
    _ normalVector: Tuple) -> Color {
        let effectiveColor = material.color * light.intensity
        let lightVector = (light.position - point).normalized()

        let ambient = effectiveColor * material.ambient

        // The dot product of the light and the normal vector represents the cosine of the angle between the light
        // vector and the normal vector. A negative number means the light is on the other side of the surface.
        // In this scenario solely the ambient lighting will be applied.
        let lightDotNormal = dot(lightVector, normalVector)
        guard lightDotNormal >= 0 else { return ambient + .black + .black }

        let diffuse = effectiveColor * material.diffuse * lightDotNormal

        // The dot product of the reflection and the normal vector represents the cosine of the angle between the
        // reflection vector and the eye vector. A negative value means that the light reflects away from the eye.
        // In case of a reflection away from the eye, no highlight (specular) reflection is visible and solely the
        // ambient and diffuse reflection will be applied.
        let reflectVector = reflect(-lightVector, normalVector)
        let reflectDotEye = dot(reflectVector, eyeVector)
        guard reflectDotEye > 0 else { return ambient + diffuse + .black }

        let factor = pow(reflectDotEye, material.shininess)
        let specular = light.intensity * material.specular * factor
        return ambient + diffuse + specular
}
