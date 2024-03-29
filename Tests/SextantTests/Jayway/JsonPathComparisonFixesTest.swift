import XCTest
import Hitch
import class Foundation.Bundle

import Sextant

class JsonPathComparisonFixesTest: TestsBase {
    // fixes: https://github.com/javerous/SMJJSONPath/issues/6
    
    func test_case1() {
        let json = #"{":": 42, "more": "string", "a": 1, "b": 2, "c": 3}"#
        XCTAssertEqualAny(json.query(values: "$[1:3]"), [])
    }
    
    func test_case2() {
        let json = #"["first", "second"]"#
        XCTAssertEqualAny(json.query(values: "$[:]"), ["first", "second"])
    }
    
    func test_case3() {
        let json = #"["first", "second"]"#
        XCTAssertEqualAny(json.query(values: "$[::]"), ["first", "second"])
    }
    
    func test_case4() {
        let json = #"["first", "second", "third", "forth", "fifth"]"#
        XCTAssertEqualAny(json.query(values: "$[0:3:2]"), ["first", "third"])
    }
    
    func test_case5() {
        let json = #"{",": "value", "another": "entry"}"#
        XCTAssertEqualAny(json.query(values: "$[',']"), ["value"])
    }
    
}

extension JsonPathComparisonFixesTest {
    static var allTests : [(String, (JsonPathComparisonFixesTest) -> () throws -> Void)] {
        return [
            ("test_case1", test_case1),
            ("test_case2", test_case2),
            ("test_case3", test_case3),
            ("test_case4", test_case4),
            ("test_case5", test_case5)
        ]
    }
}
