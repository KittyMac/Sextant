import XCTest
import class Foundation.Bundle

#if DEBUG

@testable import Sextant

class PathCompilerTest: TestsBase {
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
    
    func test_a_multi_property_token_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$['prop0', 'prop1']")?.description, "$['prop0','prop1']")
        XCTAssertEqual(PathCompiler.compile(query: "$[  'prop0'  , 'prop1'  ]")?.description, "$['prop0','prop1']")
    }
    
    func test_a_property_chain_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$.abc")?.description, "$['abc']")
        XCTAssertEqual(PathCompiler.compile(query: "$.aaa.bbb")?.description, "$['aaa']['bbb']")
        XCTAssertEqual(PathCompiler.compile(query: "$.aaa.bbb.ccc")?.description, "$['aaa']['bbb']['ccc']")
    }
    
    func test_a_property_may_not_contain_blanks() {
        let path = PathCompiler.compile(query: "$.foo bar")
        XCTAssertNil(path)
    }
    
    func test_a_wildcard_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$.*")?.description, "$[*]")
        XCTAssertEqual(PathCompiler.compile(query: "$[*]")?.description, "$[*]")
        XCTAssertEqual(PathCompiler.compile(query: "$[ * ]")?.description, "$[*]")
    }
    
    func test_a_wildcard_can_follow_a_property() {
        XCTAssertEqual(PathCompiler.compile(query: "$.prop[*]")?.description, "$['prop'][*]")
        XCTAssertEqual(PathCompiler.compile(query: "$['prop'][*]")?.description, "$['prop'][*]")
    }
    
    func test_an_array_index_path_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$[1]")?.description, "$[1]")
        XCTAssertEqual(PathCompiler.compile(query: "$[1,2,3]")?.description, "$[1,2,3]")
        XCTAssertEqual(PathCompiler.compile(query: "$[ 1 , 2 , 3 ]")?.description, "$[1,2,3]")
    }
    
    func test_an_array_slice_path_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$[-1:]")?.description, "$[-1:]")
        XCTAssertEqual(PathCompiler.compile(query: "$[1:2]")?.description, "$[1:2]")
        XCTAssertEqual(PathCompiler.compile(query: "$[:2]")?.description, "$[:2]")
    }
    
    func test_a_scan_token_can_be_parsed() {
        XCTAssertEqual(PathCompiler.compile(query: "$..['prop']..[*]")?.description, "$..['prop']..[*]")
    }
    
    func test_array_indexes_must_be_separated_by_commas() {
        let path = PathCompiler.compile(query: "$[0, 1, 2 4]")
        XCTAssertNil(path)
    }
    
    func test_trailing_comma_after_list_is_not_accepted() {
        let path = PathCompiler.compile(query: "$['1','2',]")
        XCTAssertNil(path)
    }
    
    func test_accept_only_a_single_comma_between_indexes() {
        let path = PathCompiler.compile(query: "$['1', ,'3']")
        XCTAssertNil(path)
    }
    
    func test_property_must_be_separated_by_commas() {
        let path = PathCompiler.compile(query: "$['aaa'}'bbb']")
        XCTAssertNil(path)
    }
    
    func test_an_inline_criteria_can_be_parsed() {
        XCTAssertEqual(PathCompiler.compile(query: "$[?(@.foo == 'bar')]")?.description, "$[?]")
        XCTAssertEqual(PathCompiler.compile(query: "$[?(@.foo == \"bar\")]")?.description, "$[?]")
    }
    
    func test_issue_predicate_can_have_escaped_backslash_in_prop() {
        // \\ \r \n \\
        let json = #"{"logs":[{"message":"it\\\r\n\\","id":2}]}"#
        XCTAssertEqualAny(json.query(values: #"$.logs[?(@.message == 'it\\\r\n\\')].message"#), ["it\\\r\n\\"])
        XCTAssertEqualAny(json.query(paths: #"$.logs[?(@.message == 'it\\\r\n\\')].message"#), [#"$['logs'][0]['message']"#])
    }
    
    func test_issue_predicate_can_have_bracket_in_regex() {
        let json = #"{"logs":[{"message":"(it","id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message =~ /\\(it/)].message"), [#"(it"#])
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.message =~ /\\(it/)].message"), [#"$['logs'][0]['message']"#])
    }
    
    func test_issue_predicate_can_have_and_in_regex() {
        let json = #"{"logs":[{"message":"it","id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message =~ /&&|it/)].message"), [#"it"#])
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.message =~ /&&|it/)].message"), [#"$['logs'][0]['message']"#])
    }
    
    func test_issue_predicate_can_have_and_in_prop() {
        let json = #"{"logs":[{"message":"&& it","id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message == '&& it')].message"), [#"&& it"#])
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.message == '&& it')].message"), [#"$['logs'][0]['message']"#])
    }
    
    func test_issue_predicate_brackets_must_change_priorities() {
        let json = #"{"logs":[{"id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message && (@.id == 1 || @.id == 2))].id")?.count, 0)
        XCTAssertEqualAny(json.query(values: "$.logs[?((@.id == 2 || @.id == 1) && @.message)].id")?.count, 0)
    }
    
    func test_issue_predicate_or_has_lower_priority_than_and() {
        let json = #"{"logs":[{"id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.x && @.y || @.id)]")?.count, 1)
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.x && @.y || @.id)]"), ["$[\'logs\'][0]"])
    }
    
    func test_issue_predicate_can_have_double_quotes() {
        let json = #"{"logs":[{"message":"\"it\"","id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message == '\"it\"')].message"), [#""it""#])
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.message == '\"it\"')].message"), [#"$['logs'][0]['message']"#])
    }
    
    func test_issue_predicate_can_have_single_quotes() {
        let json = #"{"logs":[{"message":"'it'","id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message == \"'it'\")].message"), [#"'it'"#])
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.message == \"'it'\")].message"), [#"$['logs'][0]['message']"#])
    }
    
    func test_issue_predicate_can_have_single_quotes_escaped() {
        let json = #"{"logs":[{"message":"'it'","id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message == '\\'it\\'')].message"), [#"'it'"#])
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.message == '\\'it\\'')].message"), [#"$['logs'][0]['message']"#])
    }
    
    func test_issue_predicate_can_have_square_bracket_in_prop() {
        let json = #"{"logs":[{"message":"] it","id":2}]}"#
        XCTAssertEqualAny(json.query(values: "$.logs[?(@.message == '] it')].message"), ["] it"])
        XCTAssertEqualAny(json.query(paths: "$.logs[?(@.message == '] it')].message"), ["$['logs'][0]['message']"])
    }
    
    func test_a_function_can_be_compiled() {
        XCTAssertEqual(PathCompiler.compile(query: "$.aaa.foo()")?.description, "$['aaa'].foo()")
        XCTAssertEqual(PathCompiler.compile(query: "$.aaa.foo(5)")?.description, "$['aaa'].foo(...)")
        XCTAssertEqual(PathCompiler.compile(query: "$.aaa.foo($.bar)")?.description, "$['aaa'].foo(...)")
        XCTAssertEqual(PathCompiler.compile(query: "$.aaa.foo(5,10,15)")?.description, "$['aaa'].foo(...)")
    }
}

extension PathCompilerTest {
    static var allTests : [(String, (PathCompilerTest) -> () throws -> Void)] {
        return [
            ("test_a_root_path_must_be_followed_by_period_or_bracket", test_a_root_path_must_be_followed_by_period_or_bracket),
            ("test_a_root_path_can_be_compiled", test_a_root_path_can_be_compiled),
            ("test_a_path_may_not_end_with_period", test_a_path_may_not_end_with_period),
            ("test_a_path_may_not_end_with_period_2", test_a_path_may_not_end_with_period_2),
            ("test_a_path_may_not_end_with_scan", test_a_path_may_not_end_with_scan),
            ("test_a_path_may_not_end_with_scan_2", test_a_path_may_not_end_with_scan_2),
            ("test_a_property_token_can_be_compiled", test_a_property_token_can_be_compiled),
            ("test_a_bracket_notation_property_token_can_be_compiled", test_a_bracket_notation_property_token_can_be_compiled),
            ("test_a_multi_property_token_can_be_compiled", test_a_multi_property_token_can_be_compiled),
            ("test_a_property_chain_can_be_compiled", test_a_property_chain_can_be_compiled),
            ("test_a_property_may_not_contain_blanks", test_a_property_may_not_contain_blanks),
            ("test_a_wildcard_can_be_compiled", test_a_wildcard_can_be_compiled),
            ("test_a_wildcard_can_follow_a_property", test_a_wildcard_can_follow_a_property),
            ("test_an_array_index_path_can_be_compiled", test_an_array_index_path_can_be_compiled),
            ("test_an_array_slice_path_can_be_compiled", test_an_array_slice_path_can_be_compiled),
            ("test_a_scan_token_can_be_parsed", test_a_scan_token_can_be_parsed),
            ("test_array_indexes_must_be_separated_by_commas", test_array_indexes_must_be_separated_by_commas),
            ("test_trailing_comma_after_list_is_not_accepted", test_trailing_comma_after_list_is_not_accepted),
            ("test_accept_only_a_single_comma_between_indexes", test_accept_only_a_single_comma_between_indexes),
            ("test_property_must_be_separated_by_commas", test_property_must_be_separated_by_commas),
            ("test_an_inline_criteria_can_be_parsed", test_an_inline_criteria_can_be_parsed),
            ("test_issue_predicate_can_have_escaped_backslash_in_prop", test_issue_predicate_can_have_escaped_backslash_in_prop),
            ("test_issue_predicate_can_have_bracket_in_regex", test_issue_predicate_can_have_bracket_in_regex),
            ("test_issue_predicate_can_have_and_in_regex", test_issue_predicate_can_have_and_in_regex),
            ("test_issue_predicate_can_have_and_in_prop", test_issue_predicate_can_have_and_in_prop),
            ("test_issue_predicate_brackets_must_change_priorities", test_issue_predicate_brackets_must_change_priorities),
            ("test_issue_predicate_or_has_lower_priority_than_and", test_issue_predicate_or_has_lower_priority_than_and),
            ("test_issue_predicate_can_have_double_quotes", test_issue_predicate_can_have_double_quotes),
            ("test_issue_predicate_can_have_single_quotes", test_issue_predicate_can_have_single_quotes),
            ("test_issue_predicate_can_have_single_quotes_escaped", test_issue_predicate_can_have_single_quotes_escaped),
            ("test_issue_predicate_can_have_square_bracket_in_prop", test_issue_predicate_can_have_square_bracket_in_prop),
            ("test_a_function_can_be_compiled", test_a_function_can_be_compiled)
        ]
    }
}

#endif
