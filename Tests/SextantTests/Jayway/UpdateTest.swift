import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class UpdateTest: TestsBase {
    
    func testUpdate0() {
        let json = #"["Hello","World"]"#
        
        json.query(replace: "$[0]", with: "Goodbye") { result in
            XCTAssertEqual(result.description, #"["Goodbye","World"]"#)
        }
        
        json.parsed { root in
            guard let root = root else { XCTFail(); return }
            root.query(replace: "$[0]", with: "Goodbye")
            root.query(replace: "$[1]", with: "Moon")
            XCTAssertEqual(root.description, #"["Goodbye","Moon"]"#)
        }
    }
}

extension UpdateTest {
    static var allTests : [(String, (UpdateTest) -> () throws -> Void)] {
        return [
            ("testUpdate0", testUpdate0),
        ]
    }
}

