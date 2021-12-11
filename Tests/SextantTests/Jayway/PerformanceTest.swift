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
    
    func testPerformance0() {
        measure {
            XCTAssertEqualAny(large0.query(values: "$[*]")?.count, 11351)
        }
    }
    
    func testPerformance1() {
        measure {
            XCTAssertEqualAny(large0.query(values: "$..type")?.count, 17906)
        }
    }
    
    func testPerformance2() {
        measure {
            XCTAssertEqualAny(large0.query(values: "$[*]")?.count, 11351)
        }
    }
    
}
