import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class ArrayPathTokenTest: TestsBase {
    let json = #"[{"foo":"foo-val-0"},{"foo":"foo-val-1"},{"foo":"foo-val-2"},{"foo":"foo-val-3"},{"foo":"foo-val-4"},{"foo":"foo-val-5"},{"foo":"foo-val-6"}]"#
    
    func test_array_can_select_multiple_indexes() {
        XCTAssertEqualAny(json.query(values: "$[0,1]"), [
            [ "foo" : "foo-val-0" ], ["foo" : "foo-val-1" ]
        ])
    }
    
    func test_array_can_be_sliced_to_2() {
        XCTAssertEqualAny(json.query(values: "$[:2]"), [
            [ "foo" : "foo-val-0" ], ["foo" : "foo-val-1" ]
        ])
    }
    
    func test_array_can_be_sliced_to_2_from_tail() {
        XCTAssertEqualAny(json.query(values: "$[:-5]"), [
            [ "foo" : "foo-val-0" ], ["foo" : "foo-val-1" ]
        ])
    }
    
    func test_array_can_be_sliced_from_2() {
        XCTAssertEqualAny(json.query(values: "$[5:]"), [
            [ "foo" : "foo-val-5" ], ["foo" : "foo-val-6" ]
        ])
    }
    
    func test_array_can_be_sliced_from_2_from_tail() {
        XCTAssertEqualAny(json.query(values: "$[-2:]"), [
            [ "foo" : "foo-val-5" ], ["foo" : "foo-val-6" ]
        ])
    }
    
    func test_array_can_be_sliced_between() {
        XCTAssertEqualAny(json.query(values: "$[2:4]"), [
            [ "foo" : "foo-val-2" ], ["foo" : "foo-val-3" ]
        ])
    }
    
}
