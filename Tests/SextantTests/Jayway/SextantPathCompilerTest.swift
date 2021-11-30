import XCTest
import class Foundation.Bundle

@testable import Sextant

class SextantPathCompilerTest: SextantTestsBase {
    var root: JsonAny = nil
    
    override func setUp() {
        root = decode(json: jsonDocument)
    }
    
    func test_a_root_path_must_be_followed_by_period_or_bracket() {
        let path = PathCompiler.compile(query: "$X")
        XCTAssertNil(path)
    }
    
    func test_a_root_path_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$")?.description, "$")
        XCTAssertEqual(PathCompiler.compile(query: "@")?.description, "@")
    }
    
    func test_a_path_may_not_end_with_period() {
        let path = PathCompiler.compile(query: "$.")
        XCTAssertNil(path)
    }
    
    func test_a_path_may_not_end_with_period_2() {
        let path = PathCompiler.compile(query: "$.prop.")
        XCTAssertNil(path)
    }
    
    func test_a_path_may_not_end_with_scan() {
        let path = PathCompiler.compile(query: "$..")
        XCTAssertNil(path)
    }
    
    func test_a_path_may_not_end_with_scan_2() {
        let path = PathCompiler.compile(query: "$.prop..")
        XCTAssertNil(path)
    }
    
    func test_a_property_token_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$.prop")?.description, "$['prop']")
        XCTAssertEqual(PathCompiler.compile(query: "$.1prop")?.description, "$['1prop']")
        XCTAssertEqual(PathCompiler.compile(query: "$.@prop")?.description, "$['@prop']")
    }
    
    func test_a_bracket_notation_property_token_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$['prop']")?.description, "$['prop']")
        XCTAssertEqual(PathCompiler.compile(query: "$['1prop']")?.description, "$['1prop']")
        XCTAssertEqual(PathCompiler.compile(query: "$['@prop']")?.description, "$['@prop']")
        XCTAssertEqual(PathCompiler.compile(query: "$[  '@prop'  ]")?.description, "$['@prop']")
        XCTAssertEqual(PathCompiler.compile(query: "$[\"prop\"]")?.description, "$[\"prop\"]")
    }
    
}
