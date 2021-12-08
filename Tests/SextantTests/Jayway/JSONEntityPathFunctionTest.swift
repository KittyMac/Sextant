import XCTest
import class Foundation.Bundle

@testable import Sextant

class JSONEntityPathFunctionTest: TestsBase {
    let jsonBatch = """
        {
            "batches": {
                "minBatchSize": 10,
                "results": [
                    {
                        "productId": 23,
                        "values": [
                            2,
                            45,
                            34,
                            23,
                            3,
                            5,
                            4,
                            3,
                            2,
                            1
                        ]
                    },
                    {
                        "productId": 23,
                        "values": [
                            52,
                            3,
                            12,
                            11,
                            18,
                            22,
                            1
                        ]
                    }
                ]
            }
        }
    """
    
    func testLengthOfTextArray() {
        XCTAssertEqualAny(jsonTextSeries.query(values: "$['text'].length()"), [6])
        XCTAssertEqualAny(jsonTextSeries.query(values: "$['text'].size()"), [6])
    }
    
    func testLengthOfNumberArray() {
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.length()"), [10])
        XCTAssertEqualAny(jsonNumberSeries.query(values: "$.numbers.size()"), [10])
    }
    
    func testLengthOfStructure() {
        XCTAssertEqualAny(jsonBatch.query(values: "$.batches.length()"), [2])
    }
    
    /**
     * The fictitious use-case/story - is we have a collection of batches with values indicating some quality metric.
     * We want to determine the average of the values for only the batch's values where the number of items in the batch
     * is greater than the min batch size which is encoded in the JSON document.
     *
     * We use the length function in the predicate to determine the number of values in each batch and then for those
     * batches where the count is greater than min we calculate the average batch value.
     *
     * Its completely contrived example, however, this test exercises functions within predicates.
     */
    func testPredicateWithFunctionCallSingleMatch() {
        let path = "$.batches.results[?(@.values.length() >= $.batches.minBatchSize)].values.avg()"
        XCTAssertEqualAny(jsonBatch.query(values: path), [12.2])
    }
    
    func testPredicateWithFunctionCallTwoMatches() {
        let path = "$.batches.results[?(@.values.length() >= 3)].values.avg()";
        XCTAssertEqualAny(jsonBatch.query(values: path), [12.2, 17])
    }
}
