import XCTest
import class Foundation.Bundle

import Sextant

class NullHandlingTest: TestsBase {
    let jsonDocumentNull = """
        {
            "root-property": "root-property-value",
            "root-property-null": null,
            "children": [
                {
                    "id": 0,
                    "name": "name-0",
                    "age": 0
                },
                {
                    "id": 1,
                    "name": "name-1",
                    "age": null
                },
                {
                    "id": 3,
                    "name": "name-3"
                }
            ]
        }
    """
    
    func test_not_defined_property_throws_PathNotFoundException() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[0].child.age"), [])
    }
    
    func test_last_token_defaults_to_null() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[2].age"), [])
    }
    
    func test_null_property_returns_null() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[0].age"), [0])
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[1].age"), [nil])
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[2].age"), [])
    }
    
    func test_the_age_of_all_with_age_defined() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[*].age"), [0, nil])
    }
}

extension NullHandlingTest {
    static var allTests : [(String, (NullHandlingTest) -> () throws -> Void)] {
        return [
            ("test_not_defined_property_throws_PathNotFoundException", test_not_defined_property_throws_PathNotFoundException),
            ("test_last_token_defaults_to_null", test_last_token_defaults_to_null),
            ("test_null_property_returns_null", test_null_property_returns_null),
            ("test_the_age_of_all_with_age_defined", test_the_age_of_all_with_age_defined),
        ]
    }
}
