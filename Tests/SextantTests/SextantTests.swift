import XCTest
import class Foundation.Bundle

import Sextant

final class SextantTests: XCTestCase {
    func testArrayIndexOpration() {
        let op = ArrayIndexOpration("1,2,20,5464,673,34")
        XCTAssertEqual(op!.description, "[1,2,20,5464,673,34]")
    }
}
