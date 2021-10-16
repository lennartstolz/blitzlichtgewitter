import Foundation

/// A rectangular grid of pixels.
///
///
/// You create a new instance with the dimensions of the canvas and a _default_ color.
///
/// ```swift
/// var c = Canvas(width: 3, height: 3, color: .white)
/// ```
///
/// Use the ``subscript(_:_:)`` operator to apply color values.
///
/// ```swift
/// c[0, 0] = .red // Applies a red color to the upper-left pixel.
/// c[1, 0] = .green // Applies a green color to the 2nd pixel of the first row.
/// c[2, 2] = .blue // Applies a blue color to the lower-right pixel.
/// ```
/// To store the canvas use the ``ppmData()`` method which returns the canvas encoded as `.ppm` file.
///
/// ```swift
/// let url = URL(fileURLWithPath: "/tmp/image.ppm")
/// try c.ppmData()?.write(to: url)
///```
///
/// You can also load a canvas from a `.ppm` files' raw data.
///
/// ```swift
/// let url = URL(fileURLWithPath: "/tmp/image.ppm")
/// let data = try! Data(contentsOf: url)
/// let c = Canvas(data: data)
/// ```
public struct Canvas {

    /// The width of the grid in pixels.
    public let width: Int

    /// The height of the grid in pixels.
    public let height: Int

    /// The (flattened) pixel data of the canvas.
    ///
    /// The pixel values are stored by rows. E.g. `pixels[4]` describes the fifth pixel of the first row (4,0) of a
    /// canvas of five-pixel width and `pixels[5]` the first pixel in the second row (0,1) of the same canvas.
    private var pixels: [Color]

    /// Creates a new canvas with the given dimensions and default color.
    ///
    /// - Parameters:
    ///     - width: The width of the grid in pixels.
    ///     - height: The height of the grid in pixels.
    ///     - color: The _default_ color applied for all pixels of the canvas.
    public init(width: Int, height: Int, color: Color = .black) {
        let pixels = [Color](repeating: color, count: width * height)
        self.init(width: width, height: height, pixels: pixels)
    }

    /// Creates a new canvas with the given dimensions and pixels.
    ///
    /// This initializer expects the correct pixel data for the given dimensions.
    /// Otherwise, it creates an invalid canvas.
    ///
    /// - Parameters:
    ///     - width: The width of the grid in pixels.
    ///     - height: The height of the grid in pixels.
    ///     - pixels: The (flattened) pixel data of the canvas.
    private init(width: Int, height: Int, pixels: [Color]) {
        assert(pixels.count == width * height)
        self.width = width
        self.height = height
        self.pixels = pixels
    }

}

extension Canvas {

    /// Accesses the pixel at the specified (x,y) position.
    ///
    /// - Parameters:
    ///     - x: The horizontal position of the pixel.
    ///     - y: The vertical position of the pixel.
    public subscript(x: Int, y: Int) -> Color {
        get {
            assert(isValidIndex(x: x, y: y), "Invalid index (\(x),\(y)).")
            return pixels[(y * width) + x]
        }
        set {
            assert(isValidIndex(x: x, y: y), "Invalid index (\(x),\(y)).")
            pixels[(y * width) + x] = newValue
        }
    }

    private func isValidIndex(x: Int, y: Int) -> Bool {
        x >= 0 && x < width && y >= 0 && y < height
    }
}

extension Canvas : Equatable { }

// MARK: Saving a Canvas

extension Canvas {

    private static let maximumColorValue: Int = 255

    /// Returns a data object that contains the specified image in PPM format.
    ///
    /// - Returns: A data object containing the PPM data, or nil if there was a problem generating the data.
    public func ppmData() -> Data? {
        """
        P3
        \(width) \(height)
        \(Self.maximumColorValue)
        \(ppmPixelData())
        """.data(using: .ascii)
    }

    /// Generates the ASCII encoded pixel data stored in the PPM files' body.
    ///
    /// This algorithm is straight-forward but an extremely inefficient way of generating the PPM pixel data.
    /// It only supports a fraction of the PPM standard and shouldn't be used as a reference.
    ///
    /// - Returns: The ASCII encoded pixel data stored in the PPM files' body.
    private func ppmPixelData() -> String {
        var data = ""
        let rows = stride(from: 0, to: pixels.count, by: width).map { pixels[$0..<$0 + width] }
        rows.forEach { row in
            var line = ""
            row.forEach { color in
                [color.red, color.green, color.blue].forEach { component in
                    let value = "\(component.scaledInRange(to: Self.maximumColorValue))"
                    if line.count + value.count >= 70 {
                        data.append(line + "\n")
                        line = "\(value)"
                    } else {
                        if line == "" {
                            line += "\(value)"
                        } else {
                            line += " \(value)"
                        }
                    }
                }
            }
            data.append(line + "\n")
        }
        return data
    }

}

private extension Color.ColorDepth {

    /// Transforms the color value (stored in the range from 0 to 1) to the range from 0 to the given max value.
    func scaledInRange(to maximumColorValue: Int) -> Int {
        let scaledValue = (self * Self(maximumColorValue)).rounded()
        return max(0, min(Int(scaledValue), 255))
    }

}

// MARK: Loading A Canvas

extension Canvas {

    /// Initializes and returns the canvas object with the specified image data.
    ///
    /// The data in the data parameter must be formatted to match the file format of "ASCII encoded PPM images".
    ///
    /// - Parameters:
    ///     - data: The data object containing the image data.
    public init?(data: Data) {
        /// This algorithm algorithm is straight-forward but an extremely inefficient way of parsing the PPM pixel data.
        /// It only supports a fraction of the PPM standard and shouldn't be used as a reference.
        let string = String(data: data, encoding: .ascii)!
        let magicNumber = string.line(1)
        guard magicNumber == "P3" else {
            assertionFailure("PPM HEADER: Only ASCII encoded images ('P3') supported.")
            return nil
        }
        let size = string.line(2).components(separatedBy: .whitespaces).compactMap(Int.init)
        guard size.count == 2 else {
            assertionFailure("PPM HEADER: Invalid size information.")
            return nil
        }

        guard let maximumColorValue = Int(string.line(3)) else {
            assertionFailure("PPM HEADER: Invalid maximum value of the color components.")
            return nil
        }

        let header = string.lines(1...3)
        let components = string
            .dropFirst(header.count)
            .components(separatedBy: .whitespacesAndNewlines)
            .compactMap(Int.init)
        let pixels: [Color] = stride(from: 0, to: components.count, by: 3).map { i in
            let red = components[i].scaledInUnitInterval(from: maximumColorValue)
            let green = components[i+1].scaledInUnitInterval(from: maximumColorValue)
            let blue = components[i+2].scaledInUnitInterval(from: maximumColorValue)
            return Color(red: red, green: green, blue: blue)
        }
        self.init(width: size[0], height: size[1], pixels: pixels)
    }

}

private extension Int {

    /// Transforms the `.ppm` color value (stored in the range from 0 to the given max value) to the range from 0 to 1.
    func scaledInUnitInterval(from maximumColorValue: Int) -> Double {
        Double(self) / Double(maximumColorValue)
    }

}

private extension String {

    /// Returns the section of the text in the given lines.
    ///
    /// This method simplifies the parsing of the PPM files.
    ///
    /// - Parameters:
    ///     - range: The range (1-indexed) of the text secion.
    ///
    /// - Retuns: The section of the text in the given lines.
    func lines(_ range: ClosedRange<Int>) -> Self {
        let zeroBasedRange:Range<Int> = (range.lowerBound - 1)..<range.upperBound
        return components(separatedBy: .newlines)[zeroBasedRange].reduce("") { $0.isEmpty ? $1 : $0 + "\n" + $1 }
    }

    /// Returns the section of the text in the given line.
    ///
    /// This method simplifies the parsing of the PPM files.
    ///
    /// - Parameters:
    ///     - number: The line (1-indexed) of the text.
    ///
    /// - Retuns: The section of the text in the given line.
    func line(_ number: Int) -> Self { lines(number...number) }

}
