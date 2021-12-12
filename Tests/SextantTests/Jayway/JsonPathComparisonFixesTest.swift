import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class JsonPathComparisonFixesTest: TestsBase {
    // fixes: https://github.com/javerous/SMJJSONPath/issues/6
    
    func test_case1() {
        // Disagree with this conclusion, we should fail with array slice on a dictionary...
        let json = #"{":": 42, "more": "string", "a": 1, "b": 2, "c": 3}"#
        XCTAssertEqualAny(json.query(values: "$[1:3]"), nil)
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
            ("test_case1", test_case1)
        ]
    }
}
