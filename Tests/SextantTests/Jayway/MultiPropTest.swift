import XCTest
import class Foundation.Bundle

@testable import Sextant

class MultiPropTest: TestsBase {
    
    func test_multi_prop_can_be_read_from_root() {
        let model = """
            {
                "a": "a-val",
                "b": "b-val",
                "c": "c-val"
            }
        """
        
        XCTAssertEqualAny(model.query(values: "$['a', 'b']"), [
            ["a": "a-val", "b": "b-val"]
        ])
        XCTAssertEqualAny(model.query(values: "$['a', 'd']"), [
            ["a": "a-val"]
        ])
    }
    
    func test_multi_props_can_be_non_leafs() {
        let json = """
            {
                "a": {
                    "v": 5
                },
                "b": {
                    "v": 4
                },
                "c": {
                    "v": 1
                }
            }
        """
        
        XCTAssertEqualAny(json.query(values: "$['a', 'c'].v"), [5, 1])
    }

    func test_nonexistent_non_leaf_multi_props_ignored() {
        let json = """
            {
                "a": {
                    "v": 5
                },
                "b": {
                    "v": 4
                },
                "c": {
                    "v": 1
                }
            }
        """
        XCTAssertEqualAny(json.query(values: "$['d', 'a', 'c', 'm'].v"), [5, 1])
    }

    func test_multi_props_with_post_filter() {
        let json = """
            {
                "a": {
                    "v": 5
                },
                "b": {
                    "v": 4
                },
                "c": {
                    "v": 1,
                    "flag": true
                }
            }
        """
        XCTAssertEqualAny(json.query(values: "$['a', 'c'][?(@.flag)].v"), [1])
    }

    func test_deep_scan_does_not_affect_non_leaf_multi_props() {
        let json = """
            {
                "a": {
                    "v": 5
                },
                "b": {
                    "v": 4
                },
                "c": {
                    "v": 1,
                    "flag": true
                }
            }
        """
        XCTAssertEqualAny(json.query(values: "$..['a', 'c'].v"), [5, 1])
        XCTAssertEqualAny(json.query(values: "$..['a', 'c'][?(@.flag)].v"), [1])
    }

    func test_multi_props_can_be_in_the_middle() {
        let json = """
            {
                "x": [
                    null,
                    {
                        "a": {
                            "v": 5
                        },
                        "b": {
                            "v": 4
                        },
                        "c": {
                            "v": 1
                        }
                    }
                ]
            }
        """
        
        XCTAssertEqualAny(json.query(values: "$.x[1]['a', 'c'].v"), [5, 1])
        XCTAssertEqualAny(json.query(values: "$.x[*]['a', 'c'].v"), [5, 1])
        XCTAssertEqualAny(json.query(values: "$[*][*]['a', 'c'].v"), [5, 1])
        XCTAssertEqualAny(json.query(values: "$.x[1]['d', 'a', 'c', 'm'].v"), [5, 1])
        XCTAssertEqualAny(json.query(values: "$.x[*]['d', 'a', 'c', 'm'].v"), [5, 1])
    }
    
}
