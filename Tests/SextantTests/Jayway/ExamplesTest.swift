import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class ExamplesTest: TestsBase {
    
    /// Each call to Sextant's query(values: ) will return an array on success and nil on failure
    func testSimple0() {
        let json = #"["Hello","World"]"#
        guard let results = json.query(values: "$[0]") else { return XCTFail() }
        XCTAssertEqualAny(results[0], "Hello")
    }
    
    /// You can avoid the provided extensions and call query on the Sextant singleton directly
    func testSimple1() {
        let json = #"["Hello","World"]"#
        guard let jsonData = json.data(using: .utf8) else { return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
        guard let results = Sextant.shared.query(jsonObject, values: "$[0]") else { return XCTFail() }
        XCTAssertEqualAny(results[0], "Hello")
    }
    
    /// Works with any existing JSON-like structure
    func testSimple2() {
        let data = [ "Hello", "World" ]
        guard let results = data.query(values: "$[0]") else { return XCTFail() }
        XCTAssertEqualAny(results[0], "Hello")
    }
    
    /// Automatically covert to simple tuples
    func testSimple3() {
        let json = #"{"name":"Rocco","age":42}"#
        
        guard let person: (name: String?, age: Int?) = json.query("$.['name','age']") else { return XCTFail() }
        XCTAssertEqual(person.name, "Rocco")
        XCTAssertEqual(person.age, 42)
    }
    
    /// Supports Decodable structs
    func testSimple4() {
        let json = #"{"data":{"people":[{"name":"Rocco","age":42},{"name":"John","age":12},{"name":"Elizabeth","age":35},{"name":"Victoria","age":85}]}}"#
        
        class Person: Decodable {
            let name: String
            let age: Int
        }
        
        guard let persons: [Person] = json.query("$..[?(@.name)]") else { return XCTFail() }
        XCTAssertEqual(persons[0].name, "Rocco")
        XCTAssertEqual(persons[0].age, 42)
        XCTAssertEqual(persons[2].name, "Elizabeth")
        XCTAssertEqual(persons[2].age, 35)
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

