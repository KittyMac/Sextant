import XCTest
import Hitch
import class Foundation.Bundle

import Sextant

class ArrayIndexFilterTest: TestsBase {
    let json = "[1, 3, 5, 7, 8, 13, 20]"
    
    func test_tail_does_not_throw_when_index_out_of_bounds() {
        XCTAssertEqualAny(json.query(values: "$[-10:]"), [1, 3, 5, 7, 8, 13, 20])
    }
    
    func test_head_does_not_throw_when_index_out_of_bounds() {
        XCTAssertEqualAny(json.query(values: "$[:10]"), [1, 3, 5, 7, 8, 13, 20])
    }
    
    func test_head_grabs_correct() {
        XCTAssertEqualAny(json.query(values: "$[:3]"), [1, 3, 5])
    }
    
    func test_tail_grabs_correct() {
        XCTAssertEqualAny(json.query(values: "$[-3:]"), [8, 13, 20])
    }
    
    func test_head_tail_grabs_correct() {
        XCTAssertEqualAny(json.query(values: "$[0:3]"), [1, 3, 5])
    }
    
    func test_can_access_items_from_end_with_negative_index() {
        XCTAssertEqualAny(json.query(values: "$[-3]"), [8])
    }
}

extension ArrayIndexFilterTest {
    static var allTests : [(String, (ArrayIndexFilterTest) -> () throws -> Void)] {
        return [
            ("test_tail_does_not_throw_when_index_out_of_bounds", test_tail_does_not_throw_when_index_out_of_bounds),
            ("test_head_does_not_throw_when_index_out_of_bounds", test_head_does_not_throw_when_index_out_of_bounds),
            ("test_head_grabs_correct", test_head_grabs_correct),
            ("test_tail_grabs_correct", test_tail_grabs_correct),
            ("test_head_tail_grabs_correct", test_head_tail_grabs_correct),
            ("test_can_access_items_from_end_with_negative_index", test_can_access_items_from_end_with_negative_index)
        ]
    }
}
