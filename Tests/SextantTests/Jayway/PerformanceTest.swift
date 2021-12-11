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
        let path: Hitch = "$[*]"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 11351)
        measure {
            _ = large0.query(values: path)
        }
    }
    
    func testPerformance1() {
        let path: Hitch = "$..type"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 17906)
        measure {
            _ = large0.query(values: path)
        }
    }
    
    func testPerformance2() {
        let path: Hitch = "$[*].payload[?(@.ref == 'master')]"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 388)
        measure {
            _ = large0.query(values: path)
        }
    }
    
    func testPerformance3() {
        let path: Hitch = "$..repo[?(@.name =~ /-/)]"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 4209)
        measure {
            _ = large0.query(values: path)
        }
    }
    
}
