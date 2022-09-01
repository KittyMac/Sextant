import XCTest
import class Foundation.Bundle

import Sextant

class NestedFunctionTest: TestsBase {
    
    func testParameterAverageFunctionCall() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.avg($.numbers.min(), $.numbers.max())"), [5.5])
    }
    
    func testArrayAverageFunctionCall() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.avg()"), [5.5])
    }
    
    
    func testArrayAverageFunctionCallWithParameters() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.sum($.numbers.min(), $.numbers.max())"), [66.0])
    }
    
    func testJsonInnerArgumentArray() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.sum(5, 3, $.numbers.max(), 2)"), [20.0])
    }
    
    func testSimpleLiteralArgument() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.sum(5)"), [5.0])
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.sum(50)"), [50.0])
    }
    
    func testStringConcat() {
        XCTAssertEqualAny(jsonTextSeries.query(values: "$.text.concat()"), ["abcdef"])
    }
    
    func testStringConcatWithJSONParameter() {
        XCTAssertEqualAny(jsonTextSeries.query(values: #"$.text.concat("-", "ghijk")"#), ["abcdef-ghijk"])
    }
    
    func testAppendNumber() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.append(11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 0).avg()"), [10.0])
    }
    
    
    func testAppendTextAndNumberThenSum() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: #"$.numbers.append("0", "11").sum()"#), [55.0])
    }
    
    func testErrantCloseBraceNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.append(0, 1, 2}).avg()"), nil)
    }
    
    func testErrantCloseBracketNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.append(0, 1, 2]).avg()"), nil)
    }
    
    func testUnclosedFunctionCallNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.append(0, 1, 2"), nil)
    }
}

extension NestedFunctionTest {
    static var allTests : [(String, (NestedFunctionTest) -> () throws -> Void)] {
        return [
            ("testParameterAverageFunctionCall", testParameterAverageFunctionCall),
            ("testArrayAverageFunctionCall", testArrayAverageFunctionCall),
            ("testArrayAverageFunctionCallWithParameters", testArrayAverageFunctionCallWithParameters),
            ("testJsonInnerArgumentArray", testJsonInnerArgumentArray),
            ("testSimpleLiteralArgument", testSimpleLiteralArgument),
            ("testStringConcat", testStringConcat),
            ("testStringConcatWithJSONParameter", testStringConcatWithJSONParameter),
            ("testAppendNumber", testAppendNumber),
            ("testAppendTextAndNumberThenSum", testAppendTextAndNumberThenSum),
            ("testErrantCloseBraceNegative", testErrantCloseBraceNegative),
            ("testErrantCloseBracketNegative", testErrantCloseBracketNegative),
            ("testUnclosedFunctionCallNegative", testUnclosedFunctionCallNegative)
        ]
    }
}
