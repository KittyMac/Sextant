import XCTest
import class Foundation.Bundle

import Sextant

class PropertyPathTokenTests: TestsBase {
    let jsonSimpleMap = """
        {
            "foo": "foo-val",
            "bar": "bar-val",
            "baz": {
                "baz-child": "baz-child-val"
            }
        }
    """
    
    let jsonSimpleArray = """
        [
            {
                "foo": "foo-val-0",
                "bar": "bar-val-0",
                "baz": {
                    "baz-child": "baz-child-val"
                }
            },
            {
                "foo": "foo-val-1",
                "bar": "bar-val-1",
                "baz": {
                    "baz-child": "baz-child-val"
                }
            }
        ]
    """
    
    func test_property_not_found() {
        XCTAssertEqual(jsonSimpleMap.query(values: "$.not-found")?.count, nil)
    }

    func test_property_not_found_deep() {
        XCTAssertEqual(jsonSimpleMap.query(values: "$.foo.not-found")?.count, nil)
    }

    func test_property_not_found_option_throw() {
        XCTAssertEqual(jsonSimpleMap.query(values: "$.not-found")?.count, nil)
    }

    func test_map_value_can_be_read_from_map() {
        XCTAssertEqualAny(jsonSimpleMap.query(values: "$.foo"), ["foo-val"])
    }

    func test_map_value_can_be_read_from_array() {
        XCTAssertEqualAny(jsonSimpleArray.query(values: "$[*].foo"), ["foo-val-0", "foo-val-1"])
    }

    func test_map_value_can_be_read_from_child_map() {
        XCTAssertEqualAny(jsonSimpleMap.query(values: "$.baz.baz-child"), ["baz-child-val"])
    }
}
 
extension PropertyPathTokenTests {
    static var allTests : [(String, (PropertyPathTokenTests) -> () throws -> Void)] {
        return [
            ("test_property_not_found", test_property_not_found),
            ("test_property_not_found_deep", test_property_not_found_deep),
            ("test_property_not_found_option_throw", test_property_not_found_option_throw),
            ("test_map_value_can_be_read_from_map", test_map_value_can_be_read_from_map),
            ("test_map_value_can_be_read_from_array", test_map_value_can_be_read_from_array),
            ("test_map_value_can_be_read_from_child_map", test_map_value_can_be_read_from_child_map)
        ]
    }
}
