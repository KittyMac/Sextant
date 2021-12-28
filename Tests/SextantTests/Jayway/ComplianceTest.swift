import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class ComplianceTest: TestsBase {
    
    func test_one() {
        let json = #"{"a":"a","b":"b","c d":"e"}"#
        
        XCTAssertEqualAny(json.query(values: "$.a"), ["a"])
        XCTAssertEqualAny(json.query(values: "$.*"), ["a","b","e"])
        XCTAssertEqualAny(json.query(values: "$[*]"), ["a","b","e"])
        XCTAssertEqualAny(json.query(values: "$['a']"), ["a"])
        XCTAssertEqualAny(json.query(values: "$.['c d']"), ["e"])
        XCTAssertEqualAny(json.query(values: "$[*]"), ["a","b","e"])
    }
    
    func test_two() {
        let json = #"[ 1, "2", 3.14, true, null ]"#
        
        XCTAssertEqualAny(json.query(values: "$[0]"), [1])
        XCTAssertEqualAny(json.query(values: "$[4]"), [nil])
        XCTAssertEqualAny(json.query(values: "$[*]"), [1, "2", 3.14, true, nil])
        XCTAssertEqualAny(json.query(values: "$[-1:]"), [nil])
    }
    
    func test_three() {
        let json = #"{"points":[{"id":"i1","x":4,"y":-5},{"id":"i2","x":-2,"y":2,"z":1},{"id":"i3","x":8,"y":3},{"id":"i4","x":-6,"y":-1},{"id":"i5","x":0,"y":2,"z":1},{"id":"i6","x":1,"y":4}]}"#
        
        XCTAssertEqualAny(json.query(values: "$.points[1]"), [["id":"i2","x":-2,"y":2,"z":1]])
        XCTAssertEqualAny(json.query(values: "$.points[4].x"), [0])
        XCTAssertEqualAny(json.query(values: "$.points[?(@.id == 'i4')].x"), [-6])
        XCTAssertEqualAny(json.query(values: "$.points[*].x"), [4,-2,8,-6,0,1])
        XCTAssertEqualAny(json.query(values: "$.points[?(@.z)].id"), ["i2","i5"])
    }
    
    func test_four() {
        let json = #"{"menu":{"header":"SVG Viewer","items":[{"id":"Open"},{"id":"OpenNew","label":"Open New"},null,{"id":"ZoomIn","label":"Zoom In"},{"id":"ZoomOut","label":"Zoom Out"},{"id":"OriginalView","label":"Original View"},null,{"id":"Quality"},{"id":"Pause"},{"id":"Mute"},null,{"id":"Find","label":"Find..."},{"id":"FindAgain","label":"Find Again"},{"id":"Copy"},{"id":"CopyAgain","label":"Copy Again"},{"id":"CopySVG","label":"Copy SVG"},{"id":"ViewSVG","label":"View SVG"},{"id":"ViewSource","label":"View Source"},{"id":"SaveAs","label":"Save As"},null,{"id":"Help"},{"id":"About","label":"About Adobe CVG Viewer..."}]}}"#
        
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@)]")?.count, 22)
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@.id == 'ViewSVG')].id"), ["ViewSVG"])
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@ && @.id == 'ViewSVG')].id"), ["ViewSVG"])
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@ && @.id && !@.label)].id"), ["Open","Quality","Pause","Mute","Copy","Help"])
    }
    
    // Further tests to ensure compliance with https://cburgmer.github.io/json-path-comparison/
    
    func test_JsonPathComparison1() {
        let json = #"{ ":": 42, "more": "string", "a": 1, "b": 2, "c": 3, "1:3": "nice" }"#
        XCTAssertEqualAny(json.query(values: "$[1:3]"), [])
    }
    
    func test_JsonPathComparison2() {
        let json = #"{ ":": 42, "more": "string" }"#
        XCTAssertEqualAny(json.query(values: "$[:]"), [])
    }
    
    func test_JsonPathComparison3() {
        let json = #"[ "first", "second", "third", "forth", "fifth" ]"#
        XCTAssertEqualAny(json.query(values: "$[0:3:0]"), ["first", "second", "third"])
    }
    
    func test_JsonPathComparison4() {
        let json = #"[ "first", "second", "third", "forth", "fifth" ]"#
        XCTAssertEqualAny(json.query(values: "$[::2]"), ["first", "third", "fifth"])
    }
    
    func test_JsonPathComparison5() {
        let json = #"{ "key": "value" }"#
        XCTAssertEqualAny(json.query(values: "$['missing']"), [])
    }
    
    func test_JsonPathComparison6() {
        let json = #"{ "u\u0308": 42 }"#
        // Note: this not matching is correct, because even though ü and ü look exactly
        // the same they are comprised differently
        XCTAssertEqualAny(json.query(values: "$['ü']"), [])
        
        let json2 = #"{ "u": 42 }"#
        XCTAssertEqualAny(json2.query(values: "$['u']"), [42])
    }
        
    func test_JsonPathComparison8() {
        let json = #"[ "one element" ]"#
        XCTAssertEqualAny(json.query(values: "$[-2]"), [])
    }
    
    func test_JsonPathComparison9() {
        let json = #"[]"#
        XCTAssertEqualAny(json.query(values: "$[-1]"), [])
    }
    
    func test_JsonPathComparison10() {
        let json = #"{ "0": "value" }"#
        XCTAssertEqualAny(json.query(values: "$[0]"), [])
    }
    
    func test_JsonPathComparison11() {
        let json = #"[ "one element" ]"#
        XCTAssertEqualAny(json.query(values: "$[1]"), [])
    }
    
    func test_JsonPathComparison12() {
        let json = #""Hello World""#
        XCTAssertEqualAny(json.query(values: "$[0]"), [])
    }
    
    func test_JsonPathComparison13() {
        let json = #"{ "single'quote": "value" }"#
        XCTAssertNil(json.query(values: "$['single'quote']"))
    }
    
    func test_JsonPathComparison14() {
        let json = #"{ "another": "entry" }"#
        XCTAssertEqualAny(json.query(values: "$['*']"), [])
    }
    
    func test_JsonPathComparison15() {
        let json = #"{ "one": { "key": "value" }, "two": { "some": "more", "key": "other value" }, "two.some": "42", "two'.'some": "43" }"#
        XCTAssertNil(json.query(values: "$['two'.'some']"))
    }
    
    func test_JsonPathComparison16() {
        let json = #"{ "one": { "key": "value" }, "two": { "some": "more", "key": "other value" }, "two.some": "42" }"#
        XCTAssertNil(json.query(values: "$[two.some]"))
    }
    
    func test_JsonPathComparison17() {
        let json = #"{ "key": "value" }"#
        XCTAssertNil(json.query(values: "$[key]"))
    }
    
    func test_JsonPathComparison18() {
        let json = #"{ "key": "value", "other": { "key": [ { "key": 42 } ] } }"#
        XCTAssertNil(json.query(values: "$.[key]"))
    }
    
    func test_JsonPathComparison19() {
        let json = #"{ "k": [ { "key": "some value" }, { "key": 42 } ], "kk": [ [ { "key": 100 }, { "key": 200 }, { "key": 300 } ], [ { "key": 400 }, { "key": 500 }, { "key": 600 } ] ], "key": [ 0, 1 ] }"#
        guard let result = (json.query(values: "$..[1].key") as? [Int]) else {
            return XCTFail()
        }
        XCTAssertEqualAny(result.sorted(), [42, 200, 500])
    }
    
    func test_JsonPathComparison20() {
        let json = #"{ "object": { "key": "value", "array": [ { "key": "something" }, { "key": { "key": "russian dolls" } } ] }, "key": "top" }"#
        XCTAssertEqualAny(json.query(values: "$...key"), nil)
    }
    
    func test_JsonPathComparison21() {
        let json = #"[ 0, 1 ]"#
        XCTAssertEqualAny(json.query(values: "$.key"), [])
    }
    
    func test_JsonPathComparison22() {
        let json = #"[ { "id": 2 } ]"#
        XCTAssertEqualAny(json.query(values: "$.id"), [])
    }
    
    func test_JsonPathComparison23() {
        let json = #"[ { "d": 1 }, { "d": 2 }, { "d": 1 }, { "d": 3 }, { "d": 4 } ]"#
        XCTAssertEqualAny(json.query(values: "$[?(@.d in [2, 3])]"), [ [ "d": 2 ], [ "d": 3 ] ])
    }
    
    func test_JsonPathComparison24() {
        let json = #"[ { "d": [ 1, 2, 3 ] }, { "d": [ 2 ] }, { "d": [ 1 ] }, { "d": [ 3, 4 ] }, { "d": [ 4, 2 ] } ]"#
        XCTAssertEqualAny(json.query(values: "$[?(2 in @.d)]"), [ [ "d": [ 1, 2, 3 ] ], [ "d": [ 2 ] ], [ "d": [ 4, 2 ] ] ])
    }
    
    func test_JsonPathComparison25() {
        let json = #"[ { "title": "Sayings of the Century", "bookmarks": [ { "page": 40 } ] }, { "title": "Sword of Honour", "bookmarks": [ { "page": 35 }, { "page": 45 } ] }, { "title": "Moby Dick", "bookmarks": [ { "page": 3035 }, { "page": 45 } ] } ]"#
        XCTAssertEqualAny(json.query(values: "$[*].bookmarks[?(@.page == 45)]^^^"), [])
    }
}

extension ComplianceTest {
    static var allTests : [(String, (ComplianceTest) -> () throws -> Void)] {
        return [
            ("test_two", test_one),
            ("test_two", test_two),
            ("test_three", test_three),
            ("test_four", test_four)
        ]
    }
}
