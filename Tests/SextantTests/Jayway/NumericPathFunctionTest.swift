import XCTest
import class Foundation.Bundle

@testable import Sextant

class NumericPathFunctionTest: TestsBase {
    
    func testAverageOfDoubles() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.avg()"), [5.5])
    }
    
    func testAverageOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.avg()"), [])
    }
    
    func testSumOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.sum()"), [55])
    }
    
    func testSumOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.sum()"), [])
    }
    
    func testMaxOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.max()"), [10])
    }
    
    func testMaxOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.max()"), [])
    }
    
    func testMinOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.min()"), [1])
    }
    
    func testMinOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.min()"), [])
    }
    
    func testStdDevOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.stddev()"), [2.8722813232690143])
    }
    
    func testStddevOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.stddev()"), [])
    }
}
