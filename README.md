# Blitzlichtgewitter

Blitzlichtgewitter is a (slow) ray tracer written in Swift.

[![build](https://github.com/lennartstolz/blitzlichtgewitter/actions/workflows/build.yml/badge.svg)](https://github.com/lennartstolz/blitzlichtgewitter/actions/workflows/build.yml)
[![test](https://github.com/lennartstolz/blitzlichtgewitter/actions/workflows/test.yml/badge.svg)](https://github.com/lennartstolz/blitzlichtgewitter/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/lennartstolz/blitzlichtgewitter/branch/main/graph/badge.svg?token=V397RT5OCO)](https://codecov.io/gh/lennartstolz/blitzlichtgewitter)

It loosely follows the steps described in [The Ray Tracer Challenge](http://raytracerchallenge.com/) by Jamis Buck.

## Current State

### Phong Reflection Model

| Ambient Reflection  | Diffuse Reflection  | Specular Reflection |       Result        |
| :-----------------: | :-----------------: | :-----------------: | :-----------------: |
| <img src="../assets/readme/phong-shading-01-ambient-reflection.png?raw=true" alt="Ambient Reflection of a sphere" width="175" /> | <img src="../assets/readme/phong-shading-02-diffuse-reflection.png?raw=true" alt="Diffuse Reflection of a sphere" width="175" /> | <img src="../assets/readme/phong-shading-03-specular-reflection.png?raw=true" alt="Specular Reflection of a sphere" width="175" /> | <img src="../assets/readme/phong-shading-04-result.png?raw=true" alt="Phong Reflection Render Result of a sphere" width="175" /> |

## Usage

The following example renders the "Result" asset from the "Phong Reflection Model" section above:

```swift
// 🟢 Creates a unit sphere.
var sphere: Sphere = .unit
// ↗️ Moves the sphere by '1.5' units along the z-axis ("away" from the camera).
sphere.transform = translation(0, 0, 1.5)
// 🎨 Applies some beautiful color ('#88B04B').
sphere.material.color = [ 136.0 / 255.0, 176.0 / 255.0, 75.0 / 255.0 ]

// 💡 Creates a point light source at the upper left corner of the scene.
let light = PointLight(position: point(-10, 10, -10), intensity: [1, 1, 1])

// 📋 Creates a 400x400 (black) canvas to draw the sphere.
var canvas = Canvas(width: 400, height: 400, color: .black)

// 🖌 Draw the sphere on the canvas.
canvas.draw(sphere: sphere, light: light)

// 💾 Writing the '.ppm' image data to disk.
let data = canvas.ppmData()
let url = URL(fileURLWithPath: "/tmp/magic.ppm")
data?.write(to: url)
```

## Roadmap

|  # | Feature                                         | Status |
| --:| ------------------------------------------------| :-----: |
|  1 | Tuples, Point and Vectors                       |    ✅   |
|  2 | Canvas                                          |    ✅   |
|  3 | Matrices                                        |    ✅   |
|  4 | Matrix Transformations                          |    ✅   |
|  5 | Ray-Tracing (Ray-Sphere Intersections)          |    ✅   |
|  6 | Light and Shading (Phong Reflection Model)      |    ✅   |
|  7 | Scene                                           |    -   |
|  8 | Shadows                                         |    -   |
|  - | Shoft Shadows (Bonus)                           |   -    |
|  9 | Planes                                          |   -    |
| 10 | Patterns                                        |   -    |
|  - | Texture Mapping (Bonus)                         |   -    |
| 11 | Reflection and Refraction                       |   -    |
| 12 | Cubes                                           |   -    |
| 13 | Cylinders                                       |   -    |
| 14 | Groups                                          |   -    |
|  - | Bounding Boxes and Hierarchies                  |   -    |
| 15 | Triangles                                       |   -    |
| 16 | CSG (Constructive Solid Geometry)               |   -    |


## API Design & Coding Style

Same as the project itself, the APIs and the coding style will evolve. It's balanced between the 
[Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and the aim staying close to the 
Cucumber (Gherkin) scenarios described in [The Ray Tracer Challenge](http://raytracerchallenge.com/).
