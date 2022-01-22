import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class UpdateTest: TestsBase {
    
    func test_replace_index_in_array() {
        let json = #"["Hello","World"]"#
        
        json.query(replace: "$[0]", with: "Goodbye") { root in
            XCTAssertEqual(root.description, #"["Goodbye","World"]"#)
        }
        
        json.query(replace: [
            "$[0]",
            "$[1]"
        ], with: "Goodbye") { root in
            XCTAssertEqual(root.description, #"["Goodbye","Goodbye"]"#)
        }
        
        json.parsed { root in
            guard let root = root else { XCTFail(); return }
            root.query(replace: "$[0]", with: "Goodbye")
            root.query(replace: "$[1]", with: "Moon")
            XCTAssertEqual(root.description, #"["Goodbye","Moon"]"#)
        }
    }
    
    func test_foreach_index_in_array() {
        let json = #"[0,1,2,3,4,5,6,7,8,9]"#
                
        json.query(forEach: "$[*]", { $0.valueInt *= 10 }) { root in
            XCTAssertEqual(root.description, #"[0,10,20,30,40,50,60,70,80,90]"#)
        }
        
        let json2 = #"["John","Jackie","Jason"]"#
        json2.parsed { root in
            guard let root = root else { XCTFail(); return }
            
            print(root)
            
            // TODO: it would be nice if valueString was not a halfhitch here, as this is annoying
            // or if calling a mutating thing (like lowercase()) were possible on a halfhitch in a non-destructive way, then
            // this could simply be $0.valueString.lowercase()
            root.query(forEach: "$[*]") { $0.valueString = $0.valueString.hitch().lowercase().halfhitch() }
            XCTAssertEqual(root.description, #"["john","jackie","jason"]"#)
            root.query(forEach: "$[*]") { $0.valueString = $0.valueString.hitch().uppercase().halfhitch() }
            XCTAssertEqual(root.description, #"["JOHN","JACKIE","JASON"]"#)
        }
    }
    
    func test_filter_index_in_array() {
        let json = #"["Hello","World"]"#
        
        // TODO: implement filter
        json.query(replace: "$[0]", with: "Goodbye") { root in
            XCTAssertEqual(root.description, #"["Goodbye","World"]"#)
        }
        
        json.query(replace: [
            "$[0]",
            "$[1]"
        ], with: "Goodbye") { root in
            XCTAssertEqual(root.description, #"["Goodbye","Goodbye"]"#)
        }
        
        json.parsed { root in
            guard let root = root else { XCTFail(); return }
            root.query(replace: "$[0]", with: "Goodbye")
            root.query(replace: "$[1]", with: "Moon")
            XCTAssertEqual(root.description, #"["Goodbye","Moon"]"#)
        }
    }
    
    func test_an_array_child_property_can_be_updated() {
        jsonDocument.query(replace: "$.store.book[*].display-price", with: 1) { root in
            guard let results = root.query(values: "$.store.book[*].display-price") else { XCTFail(); return }
            XCTAssertEqualAny(results, [1, 1, 1, 1])
        }
    }
}

extension UpdateTest {
    static var allTests : [(String, (UpdateTest) -> () throws -> Void)] {
        return [
            ("test_replace_index_in_array", test_replace_index_in_array),
        ]
    }
}

