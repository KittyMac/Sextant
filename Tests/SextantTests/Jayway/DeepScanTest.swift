import XCTest
import HitchKit
import Foundation

@testable import SextantKit

class DeepScanTest: TestsBase {
    
    func test_when_deep_scanning_non_array_subscription_is_ignored() {
        XCTAssertEqualAny("{\"x\": [0,1,[0,1,2,3,null],null]}".query(values: "$..[2][3]"), [3])
        XCTAssertEqualAny("{\"x\": [0,1,[0,1,2,3,null],null], \"y\": [0,1,2]}".query(values: "$..[2][3]"), [3])
        XCTAssertEqualAny("{\"x\": [0,1,[0,1,2],null], \"y\": [0,1,2]}".query(values: "$..[2][3]"), [])
    }
    
    func test_when_deep_scanning_null_subscription_is_ignored() {
        XCTAssertEqualAny("{\"x\": [null,null,[0,1,2,3,null],null]}".query(values: "$..[2][3]"), [3])
        XCTAssertEqualAny("{\"x\": [null,null,[0,1,2,3,null],null], \"y\": [0,1,null]}".query(values: "$..[2][3]"), [3])
    }
    
    func test_when_deep_scanning_array_index_oob_is_ignored() {
        XCTAssertEqualAny("{\"x\": [0,1,[0,1,2,3,10],null]}".query(values: "$..[4]"), [10])
        XCTAssertEqualAny("{\"x\": [null,null,[0,1,2,3]], \"y\": [null,null,[0,1]]}".query(values: "$..[2][3]"), [3])
    }
    
    func test_definite_upstream_illegal_array_access_throws() {
        XCTAssertEqualAny("{\"foo\": {\"bar\": null}}".query(values: "$.foo.bar.[5]"), [])
        //XCTAssertEqualAny("{\"foo\": {\"bar\": null}}".query(values: "$.foo.bar.[5, 10]"), [])
        //XCTAssertEqualAny("{\"foo\": {\"bar\": 4}}".query(values: "$.foo.bar.[5]"), [])
        //XCTAssertEqualAny("{\"foo\": {\"bar\": 4}}".query(values: "$.foo.bar.[5, 10]"), [])
        //XCTAssertEqualAny("{\"foo\": {\"bar\": []}}".query(values: "$.foo.bar.[5]"), [])
    }
    
    func test_when_deep_scanning_illegal_property_access_is_ignored() {
        XCTAssertEqualAny("{\"x\": {\"foo\": {\"bar\": 4}}, \"y\": {\"foo\": 1}}".query(values: "$..foo")?.count, 2)
        XCTAssertEqualAny("{\"x\": {\"foo\": {\"bar\": 4}}, \"y\": {\"foo\": 1}}".query(values: "$..foo.bar"), [4])
        XCTAssertEqualAny("{\"x\": {\"foo\": {\"bar\": 4}}, \"y\": {\"foo\": 1}}".query(values: "$..[*].foo.bar"), [4])
        XCTAssertEqualAny("{\"x\": {\"foo\": {\"baz\": 4}}, \"y\": {\"foo\": 1}}".query(values: "$..[*].foo.bar"), [])
    }
    
    func test_when_deep_scanning_illegal_predicate_is_ignored() {
        XCTAssertEqualAny("{\"x\": {\"foo\": {\"bar\": 4}}, \"y\": {\"foo\": 1}}".query(values: "$..foo[?(@.bar)].bar"), [4])
        XCTAssertEqualAny("{\"x\": {\"foo\": {\"bar\": 4}}, \"y\": {\"foo\": 1}}".query(values: "$..[*]foo[?(@.bar)].bar"), [4])
    }
    
    func test_when_deep_scanning_require_properties_is_ignored_on_scan_target() {
        XCTAssertEqualAny("[{\"x\": {\"foo\": {\"x\": 4}, \"x\": null}, \"y\": {\"x\": 1}}, {\"x\": []}]".query(values: "$..x")?.count, 5)
        XCTAssertEqualAny("{\"foo\": {\"bar\": 4}}".query(values: "$..foo.bar"), [4])
        XCTAssertEqualAny("{\"foo\": {\"baz\": 4}}".query(values: "$..foo.bar"), [])
    }
    
    func test_when_deep_scanning_require_properties_is_ignored_on_scan_target_but_not_on_children() {
        XCTAssertEqualAny("{\"foo\": {\"baz\": 4}}".query(values: "$..foo.bar"), [])
    }
    
    func test_when_deep_scanning_leaf_multi_props_work() {
        XCTAssertEqualAny(#"[{"a": "a-val", "b": "b-val", "c": "c-val"}, [1, 5], {"a": "a-val"}]"#.query(values: "$..['a', 'c']"), [ "a-val", "c-val", "a-val" ])
    }
    
    func test_require_single_property_ok() {
        XCTAssertEqualAny(#"[{"a":"a0"},{"a":"a1"}]"#.query(values: "$..a"), ["a0", "a1"])
    }
    
    func test_require_single_property() {
        XCTAssertEqualAny(#"[{"a":"a0"},{"b":"b2"}]"#.query(values: "$..a"), ["a0"])
    }
    
    func test_require_multi_property_all_match() {
        let json = #"[{"a":"aa","b":"bb"},{"a":"aa","b":"bb"}]"#
        XCTAssertEqualAny(json.query(values: "$..['a', 'b']"), ["aa","bb","aa","bb"])
    }
    
    func test_require_multi_property_some_match() {
        let json = #"[{"a":"aa","b":"bb"},{"a":"aa","d":"dd"}]"#
        XCTAssertEqualAny(json.query(values: "$..['a', 'b']"), ["aa","bb","aa"])
    }
    
    func test_scan_for_single_property() {
        let json = #"[{"a":"aa"},{"b":"bb"},{"b":{"b":"bb"},"ab":{"a":{"a":"aa"},"b":{"b":"bb"}}}]"#
        XCTAssertEqualAny(json.query(values: "$..['a']"), ["aa", ["a":"aa"], "aa"])
    }
    
    func test_scan_for_property_path() {
        let json = #"[{"a":"aa"},{"x":"xx"},{"a":{"x":"xx"}},{"z":{"a":{"x":"xx"}}}]"#
        XCTAssertEqualAny(json.query(values: "$..['a'].x"), ["xx", "xx"])
    }
    
    func test_scan_for_property_path_missing_required_property() {
        let json = #"[{"a":"aa"},{"x":"xx"},{"a":{"x":"xx"}},{"z":{"a":{"x":"xx"}}}]"#
        XCTAssertEqualAny(json.query(values: "$..['a'].x"), ["xx", "xx"])
    }
    
    func test_scans_can_be_filtered() {
        let json = #"[{"color":{"val":"brown"},"mammal":true},{"color":{"val":"white"},"mammal":true},{"mammal":false}]"#
        XCTAssertEqualAny(json.query(values: "$..[?(@.mammal == true)].color"), [["val":"brown"], ["val":"white"]])
    }
    
    func test_scan_with_a_function_filter() {
        XCTAssertEqualAny(jsonDocument.query(values: "$..*[?(@.length() > 5)]")?.count, 1)
    }
    
    func test_deepScanPathDefault() {
        let json = "{ \"index\": \"index\", \"data\": { \"array\": [ { \"object1\": { \"name\": \"robert\" } } ] } }"
        XCTAssertEqualAny(json.query(values: "$..array[0]"), [["object1":["name":"robert"]]])
    }
}

extension DeepScanTest {
    static var allTests : [(String, (DeepScanTest) -> () throws -> Void)] {
        return [
            ("test_when_deep_scanning_non_array_subscription_is_ignored", test_when_deep_scanning_non_array_subscription_is_ignored),
            ("test_when_deep_scanning_null_subscription_is_ignored", test_when_deep_scanning_null_subscription_is_ignored),
            ("test_when_deep_scanning_array_index_oob_is_ignored", test_when_deep_scanning_array_index_oob_is_ignored),
            ("test_definite_upstream_illegal_array_access_throws", test_definite_upstream_illegal_array_access_throws),
            ("test_when_deep_scanning_illegal_property_access_is_ignored", test_when_deep_scanning_illegal_property_access_is_ignored),
            ("test_when_deep_scanning_illegal_predicate_is_ignored", test_when_deep_scanning_illegal_predicate_is_ignored),
            ("test_when_deep_scanning_require_properties_is_ignored_on_scan_target", test_when_deep_scanning_require_properties_is_ignored_on_scan_target),
            ("test_when_deep_scanning_require_properties_is_ignored_on_scan_target_but_not_on_children", test_when_deep_scanning_require_properties_is_ignored_on_scan_target_but_not_on_children),
            ("test_when_deep_scanning_leaf_multi_props_work", test_when_deep_scanning_leaf_multi_props_work),
            ("test_require_single_property_ok", test_require_single_property_ok),
            ("test_require_single_property", test_require_single_property),
            ("test_require_multi_property_all_match", test_require_multi_property_all_match),
            ("test_require_multi_property_some_match", test_require_multi_property_some_match),
            ("test_scan_for_single_property", test_scan_for_single_property),
            ("test_scan_for_property_path", test_scan_for_property_path),
            ("test_scan_for_property_path_missing_required_property", test_scan_for_property_path_missing_required_property),
            ("test_scans_can_be_filtered", test_scans_can_be_filtered),
            ("test_scan_with_a_function_filter", test_scan_with_a_function_filter),
            ("test_deepScanPathDefault", test_deepScanPathDefault)
        ]
    }
}
