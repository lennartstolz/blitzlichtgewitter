import XCTest
import Blitzlichtgewitter

final class MaterialTests : XCTestCase {

    func testTheDefaultMaterial() {
        let m = Material()
        XCTAssertEqual(m.color, [1, 1, 1])
        XCTAssertEqual(m.ambient, 0.1)
        XCTAssertEqual(m.diffuse, 0.9)
        XCTAssertEqual(m.specular, 0.9)
        XCTAssertEqual(m.shininess, 200)
    }

}
