import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class PerformanceTest: TestsBase {
    private var large0: JsonAny = nil
    
    override func setUp() {
        let largeDataPath = "/Volumes/Storage/large.json"
        let largeData = try! Data(contentsOf: URL(fileURLWithPath: largeDataPath))
        large0 = try! JSONSerialization.jsonObject(with: largeData, options: [])
    }
    
    func testSanity0() {
        XCTAssertEqualAny(large0.query(values: "$[*]")?.count, 5)
    }
    
    func testPerformance0() {
        measure {
            for x in 1...1000 {
                large0.query(values: "$..type")
            }
        }
    }
    
}
