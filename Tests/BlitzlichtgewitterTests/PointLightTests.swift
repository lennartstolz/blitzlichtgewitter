import XCTest
import Blitzlichtgewitter

final class PointLightTests : XCTestCase {

    func testAPointLightHasAPositionAndIntensity() {
        let intensity : Color = [ 0, 0, 0 ]
        let position = point(0, 0, 0)
        let light = PointLight(position: position, intensity: intensity)
        XCTAssertEqual(light.position, position)
        XCTAssertEqual(light.intensity, intensity)
    }

}
