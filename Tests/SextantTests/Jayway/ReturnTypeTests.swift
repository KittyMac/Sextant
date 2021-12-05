import XCTest
import class Foundation.Bundle

import Sextant

class ReturnTypeTests: TestsBase {
    var root: JsonAny = nil
    
    override func setUp() {
        root = decode(json: jsonDocument)
    }
    
    func test_assert_strings_can_be_read() {
        XCTAssertEqual(root.query(values: "$.string-property").first as? String, "string-value")
        XCTAssertEqual(root.query(paths: "$.string-property").first as? String, "$['string-property']")
    }
    
    func test_assert_ints_can_be_read() {
        XCTAssertEqual(root.query(values: "$.int-max-property").first as? UInt32, UINT32_MAX)
        XCTAssertEqual(root.query(paths: "$.int-max-property").first as? String, "$['int-max-property']")
    }
    
    func test_assert_longs_can_be_read() {
        XCTAssertEqual(root.query(values: "$.long-max-property").first as? UInt64, UINT64_MAX)
        XCTAssertEqual(root.query(paths: "$.long-max-property").first as? String, "$['long-max-property']")
    }
    
    func test_assert_boolean_values_can_be_read() {
        XCTAssertEqual(root.query(values: "$.boolean-property").first as? Bool, true)
        XCTAssertEqual(root.query(paths: "$.boolean-property").first as? String, "$['boolean-property']")
    }
    
    func test_assert_arrays_can_be_read() {
        XCTAssertEqual((root.query(values: "$.store.book").first as? JsonArray)?.count, 4)
        XCTAssertEqual(root.query(paths: "$.store.book").first as? String, "$['store']['book']")
    }
    
    func test_assert_maps_can_be_read() {
        XCTAssertEqualAny(root.query(values: "$.store.book[0]"), [
            [
                "author": "Nigel Rees",
                "title": "Sayings of the Century",
                "display-price": 8.95,
                "category": "reference"
            ]
        ])
        XCTAssertEqual(root.query(paths: "$.store.book[0]").first as? String, "$['store']['book'][0]")
    }
    
    func test_a_path_evaluation_can_be_returned_as_PATH_LIST() {
        XCTAssertEqualAny(root.query(paths: "$..author"), [
            "$['store']['book'][0]['author']",
            "$['store']['book'][1]['author']",
            "$['store']['book'][2]['author']",
            "$['store']['book'][3]['author']"
        ])
    }
}
