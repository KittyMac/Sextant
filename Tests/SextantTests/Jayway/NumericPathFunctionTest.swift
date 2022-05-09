import XCTest
import Foundation

@testable import SextantKit

class NumericPathFunctionTest: TestsBase {
    
    func testAverageOfDoubles() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.avg()"), [5.5])
    }
    
    func testAverageOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.avg()"), nil)
    }
    
    func testSumOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.sum()"), [55])
    }
    
    func testSumOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.sum()"), nil)
    }
    
    func testMaxOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.max()"), [10])
    }
    
    func testMaxOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.max()"), nil)
    }
    
    func testMinOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.min()"), [1])
    }
    
    func testMinOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.min()"), nil)
    }
    
    func testStdDevOfDouble() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.stddev()"), [2.8722813232690143])
    }
    
    func testStddevOfEmptyListNegative() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.empty.stddev()"), nil)
    }
}

extension NumericPathFunctionTest {
    static var allTests : [(String, (NumericPathFunctionTest) -> () throws -> Void)] {
        return [
            ("testAverageOfDoubles", testAverageOfDoubles),
            ("testAverageOfEmptyListNegative", testAverageOfEmptyListNegative),
            ("testSumOfDouble", testSumOfDouble),
            ("testSumOfEmptyListNegative", testSumOfEmptyListNegative),
            ("testMaxOfDouble", testMaxOfDouble),
            ("testMaxOfEmptyListNegative", testMaxOfEmptyListNegative),
            ("testMinOfDouble", testMinOfDouble),
            ("testMinOfEmptyListNegative", testMinOfEmptyListNegative),
            ("testStdDevOfDouble", testStdDevOfDouble),
            ("testStddevOfEmptyListNegative", testStddevOfEmptyListNegative)
        ]
    }
}
