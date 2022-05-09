import XCTest
import HitchKit
import Foundation

@testable import SextantKit

class ArraySlicingTest: TestsBase {
    let jsonArray = "[1, 3, 5, 7, 8, 13, 20]"
    
    func test_get_by_position() {
        XCTAssertEqualAny(jsonArray.query(values: "$[3]"), [7])
    }
    
    func test_get_from_index() {
        XCTAssertEqualAny(jsonArray.query(values: "$[:3]"), [ 1, 3, 5 ])
    }

    func test_get_between_index() {
        XCTAssertEqualAny(jsonArray.query(values: "$[1:5]"), [ 3, 5, 7, 8 ])
    }

    func test_get_between_index_2() {
        XCTAssertEqualAny(jsonArray.query(values: "$[0:1]"), [ 1 ])
    }

    func test_get_between_index_3() {
        XCTAssertEqualAny(jsonArray.query(values: "$[0:2]"), [ 1, 3 ])
    }

    func test_get_between_index_out_of_bounds() {
        XCTAssertEqualAny(jsonArray.query(values: "$[1:15]"), [ 3, 5, 7, 8, 13, 20 ])
    }

    func test_get_from_tail_index() {
        XCTAssertEqualAny(jsonArray.query(values: "$[-3:]"), [ 8, 13, 20 ])
    }

    func test_get_from_tail() {
        XCTAssertEqualAny(jsonArray.query(values: "$[3:]"), [ 7, 8, 13, 20 ])
    }

    func test_get_indexes() {
        XCTAssertEqualAny(jsonArray.query(values: "$[0,1,2]"), [ 1, 3, 5 ])
    }
}

extension ArraySlicingTest {
    static var allTests : [(String, (ArraySlicingTest) -> () throws -> Void)] {
        return [
            ("test_get_by_position", test_get_by_position),
            ("test_get_from_index", test_get_from_index),
            ("test_get_between_index", test_get_between_index),
            ("test_get_between_index_2", test_get_between_index_2),
            ("test_get_between_index_3", test_get_between_index_3),
            ("test_get_between_index_out_of_bounds", test_get_between_index_out_of_bounds),
            ("test_get_from_tail_index", test_get_from_tail_index),
            ("test_get_from_tail", test_get_from_tail),
            ("test_get_indexes", test_get_indexes)
        ]
    }
}
