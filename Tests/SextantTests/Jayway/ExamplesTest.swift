import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class ExamplesTest: TestsBase {
    
    func testSimple0() {
        let json = #"["Hello","World"]"#
        
        if let arrayOfResults = json.query(values: "$[0]") {
            XCTAssertEqualAny(arrayOfResults[0], "Hello")
        }
    }
    
    func testSimple1() {
        let json = #"["Hello","World"]"#
        guard let jsonData = json.data(using: .utf8) else { return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
        
        if let arrayOfResults = Sextant.shared.query(jsonObject, values: "$[0]") {
            XCTAssertEqualAny(arrayOfResults[0], "Hello")
        }
    }
    
    func testSimple2() {
        let data = [
            "Hello",
            "World"
        ]
        if let arrayOfResults = Sextant.shared.query(data, values: "$[0]") {
            XCTAssertEqualAny(arrayOfResults[0], "Hello")
        }
    }
}

extension ExamplesTest {
    static var allTests : [(String, (ExamplesTest) -> () throws -> Void)] {
        return [
            ("testSimple0", testSimple0),
            ("testSimple1", testSimple1),
            ("testSimple2", testSimple2),
        ]
    }
}

