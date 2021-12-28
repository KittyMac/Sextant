import XCTest
import Hitch
import Spanker
import class Foundation.Bundle

@testable import Sextant

class PerformanceTest: TestsBase {
    private var largeData0: Data = Data()
    private var large0: JsonAny = nil
    
    override func setUp() {
        let largeDataPath = "/Volumes/Storage/large.json"
        largeData0 = try! Data(contentsOf: URL(fileURLWithPath: largeDataPath))
        large0 = try! JSONSerialization.jsonObject(with: largeData0, options: [])
    }
    
    func testPerformance0() {
        // 0.007
        
        let path: Hitch = "$[*]"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 11351)
        measure {
            _ = large0.query(values: path)
        }
    }
    
    func testSpankerPerformance0() {
        // 0.006
        
        let path: Hitch = "$[*]"

        largeData0.parsed { json in
            guard let json = json else { XCTFail(); return }
            XCTAssertEqualAny(json.query(values: path)?.count, 11351)
            
            measure {
                _ = json.query(values: path)
            }
        }
    }
    
    func testPerformance1() {
        // 0.881
        // 0.891
        let path: Hitch = "$..type"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 17906)
        measure {
            _ = large0.query(values: path)
        }
    }
    
    func testSpankerPerformance1() {
        // 0.135
        // 0.122
        // 0.104
        // 0.097
        // -- Spanker now unescapes all strings --
        // 0.104
        // -- Evaluation options allows paths to be skipped --
        // 0.095
        // 0.088
        // 0.086
        let path: Hitch = "$..type"
        
        largeData0.parsed { json in
            guard let json = json else { XCTFail(); return }
            XCTAssertEqualAny(json.query(values: path)?.count, 17906)
            
            measure {
                _ = json.query(values: path)
            }
        }
    }
    
    func testPerformance2() {
        // 0.198
        
        let path: Hitch = "$[*].payload[?(@.ref == 'master')]"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 388)
        measure {
            _ = large0.query(values: path)
        }
    }
    
    func testSpankerPerformance2() {
        // 0.070
        // 0.064
        
        let path: Hitch = "$[*].payload[?(@.ref == 'master')]"

        largeData0.parsed { json in
            guard let json = json else { XCTFail(); return }
            XCTAssertEqualAny(json.query(values: path)?.count, 388)
            
            measure {
                _ = json.query(values: path)
            }
        }
    }
    
    func testPerformance3() {
        // 1.193
        
        let path: Hitch = "$..repo[?(@.name =~ /-/)]"
        
        XCTAssertEqualAny(large0.query(values: path)?.count, 4209)
        measure {
            _ = large0.query(values: path)
        }
    }
    
    func testSpankerPerformance3() {
        // 0.268
        // 0.205
        let path: Hitch = "$..repo[?(@.name =~ /-/)]"

        largeData0.parsed { json in
            guard let json = json else { XCTFail(); return }
            XCTAssertEqualAny(json.query(values: path)?.count, 4209)
            
            measure {
                _ = json.query(values: path)
            }
        }
    }
    
}
