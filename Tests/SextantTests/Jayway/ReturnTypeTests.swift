import XCTest
import class Foundation.Bundle

import Sextant

class ReturnTypeTests: TestsBase {
    var root: JsonAny = nil
    
    override func setUp() {
        root = decode(json: jsonDocument)
    }
    
    func test_assert_strings_can_be_read() {
        XCTAssertEqualAny(root.query(values: "$.string-property"), ["string-value"])
        XCTAssertEqualAny(root.query(paths: "$.string-property"), ["$['string-property']"])
    }
    
    func test_assert_ints_can_be_read() {
        XCTAssertEqualAny(root.query(values: "$.int-max-property"), [UINT32_MAX])
        XCTAssertEqualAny(root.query(paths: "$.int-max-property"), ["$['int-max-property']"])
    }
    
    func test_assert_longs_can_be_read() {
        XCTAssertEqualAny(root.query(values: "$.long-max-property"), [SIZE_MAX])
        XCTAssertEqualAny(root.query(paths: "$.long-max-property"), ["$['long-max-property']"])
    }
    
    func test_assert_boolean_values_can_be_read() {
        XCTAssertEqualAny(root.query(values: "$.boolean-property"), [true])
        XCTAssertEqualAny(root.query(paths: "$.boolean-property"), ["$['boolean-property']"])
    }
    
    func test_assert_arrays_can_be_read() {
        XCTAssertEqualAny((root.query(values: "$.store.book")?.first as? JsonArray)?.count, 4)
        XCTAssertEqualAny(root.query(paths: "$.store.book"), ["$['store']['book']"])
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
        XCTAssertEqualAny(root.query(paths: "$.store.book[0]"), ["$['store']['book'][0]"])
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

extension ReturnTypeTests {
    static var allTests : [(String, (ReturnTypeTests) -> () throws -> Void)] {
        return [
            ("test_assert_strings_can_be_read", test_assert_strings_can_be_read),
            ("test_assert_ints_can_be_read", test_assert_ints_can_be_read),
            ("test_assert_longs_can_be_read", test_assert_longs_can_be_read),
            ("test_assert_boolean_values_can_be_read", test_assert_boolean_values_can_be_read),
            ("test_assert_arrays_can_be_read", test_assert_arrays_can_be_read),
            ("test_assert_maps_can_be_read", test_assert_maps_can_be_read),
            ("test_a_path_evaluation_can_be_returned_as_PATH_LIST", test_a_path_evaluation_can_be_returned_as_PATH_LIST)
        ]
    }
}
