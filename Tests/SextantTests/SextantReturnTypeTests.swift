import XCTest
import class Foundation.Bundle

import Sextant

class SextantReturnTypeTests: SextantTestsBase {
    
    func test_assert_strings_can_be_read() {
        let json = decode(json: jsonDocument)
        XCTAssertEqual(Sextant.shared.values(root: json, path: "$.string-property").first as? String, "string-value")
        XCTAssertEqual(Sextant.shared.paths(root: json, path: "$.string-property").first as? String, "$['string-property']")
    }
    
    
}
