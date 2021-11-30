import XCTest
import class Foundation.Bundle

import Sextant

class SextantReturnTypeTests: SextantTestsBase {
    var json: JsonAny = nil
    
    override func setUp() {
        json = decode(json: jsonDocument)
    }
    
    func test_assert_strings_can_be_read() {
        XCTAssertEqual(Sextant.shared.values(root: json, path: "$.string-property").first as? String, "string-value")
        XCTAssertEqual(Sextant.shared.paths(root: json, path: "$.string-property").first as? String, "$['string-property']")
    }
    
    func test_assert_ints_can_be_read() {
        XCTAssertEqual(Sextant.shared.values(root: json, path: "$.int-max-property").first as? UInt32, UINT32_MAX)
        XCTAssertEqual(Sextant.shared.paths(root: json, path: "$.int-max-property").first as? String, "$['int-max-property']")
    }
    
    func test_assert_longs_can_be_read() {
        XCTAssertEqual(Sextant.shared.values(root: json, path: "$.long-max-property").first as? UInt64, UINT64_MAX)
        XCTAssertEqual(Sextant.shared.paths(root: json, path: "$.long-max-property").first as? String, "$['long-max-property']")
    }
    
    func test_assert_boolean_values_can_be_read() {
        XCTAssertEqual(Sextant.shared.values(root: json, path: "$.boolean-property").first as? Bool, true)
        XCTAssertEqual(Sextant.shared.paths(root: json, path: "$.boolean-property").first as? String, "$['boolean-property']")
    }
    
    func test_assert_arrays_can_be_read() {
        XCTAssertEqual((Sextant.shared.values(root: json, path: "$.store.book").first as? [JsonAny])?.count, 4)
        XCTAssertEqual(Sextant.shared.paths(root: json, path: "$.store.book").first as? String, "$['store']['book']")
    }
    
    func test_assert_maps_can_be_read() {
        print(Sextant.shared.values(root: json, path: "$.store.book[0]"))
        //XCTAssertEqual((Sextant.shared.values(root: json, path: "$.store.book[0]").first as? [JsonAny]), [])
        XCTAssertEqual(Sextant.shared.paths(root: json, path: "$.store.book[0]").first as? String, "$['store']['book'][0]")
    }
}
