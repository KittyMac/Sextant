import XCTest
import Hitch
import Spanker
import class Foundation.Bundle

@testable import Sextant

class ThreadedTest: TestsBase {
    private var largeData0: Data = Data()
    private var large0: JsonAny = nil
    
    override func setUp() {
        let largeDataPath = "/Volumes/Storage/large.json"
        largeData0 = try! Data(contentsOf: URL(fileURLWithPath: largeDataPath))
        large0 = try! JSONSerialization.jsonObject(with: largeData0, options: [])
    }
        
    func testThreads0() {
        // Ensure that sharing cached paths across threads does not cause bad things to happen
        let path: Hitch = "$..type"
        let expectation = XCTestExpectation(description: "success")

        var threadsDone = 0
        for _ in 0..<20 {
            Thread {
                self.largeData0.parsed { json in
                    guard let json = json else { XCTFail(); return }
                    XCTAssertEqualAny(json.query(values: path)?.count, 17906)
                    
                    for _ in 0..<10 {
                        _ = json.query(values: path)
                    }
                }
                
                threadsDone += 1
                if threadsDone == 20 {
                    expectation.fulfill()
                }
            }.start()
        }
        
        wait(for: [expectation], timeout: 30)
    }
    
}
