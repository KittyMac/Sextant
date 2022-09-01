import XCTest
import class Foundation.Bundle

import Sextant

class InlineFilterTest: TestsBase {
    
    func test_root_context_can_be_referred_in_predicate() {
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[?(@.display-price <= $.max-price)].display-price"), [8.95, 8.99])
    }
    
    func test_multiple_context_object_can_be_refered() {
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?(@.category == @.category) ]")?.count, 4)
        
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?(@.category == @['category']) ]")?.count, 4)
        
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?(@ == @) ]")?.count, 4)
        
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?(@.category != @.category) ]")?.count, 0)
        
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?(@.category != @) ]")?.count, 4)
    }
    
    func test_simple_inline_or_statement_evaluates() {
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?(@.author == 'Nigel Rees' || @.author == 'Evelyn Waugh') ].author"), ["Nigel Rees", "Evelyn Waugh"])
        
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?((@.author == 'Nigel Rees' || @.author == 'Evelyn Waugh') && @.display-price < 15) ].author"), ["Nigel Rees", "Evelyn Waugh"])
        
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?((@.author == 'Nigel Rees' || @.author == 'Evelyn Waugh') && @.category == 'reference') ].author"), ["Nigel Rees"])
        
        XCTAssertEqualAny(jsonDocument.query(values: "store.book[ ?((@.author == 'Nigel Rees') || (@.author == 'Evelyn Waugh' && @.category != 'fiction')) ].author"), ["Nigel Rees"])
    }
    
    func test_no_path_ref_in_filter_hit_all() {
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?('a' == 'a')].author"), ["Nigel Rees", "Evelyn Waugh", "Herman Melville", "J. R. R. Tolkien"])
    }
    
    func test_no_path_ref_in_filter_hit_none() {
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?('a' == 'b')].author"), [])
    }
    
    func test_path_can_be_on_either_side_of_operator() {
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(@.category == 'reference')].author"), [ "Nigel Rees" ])
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?('reference' == @.category)].author"), [ "Nigel Rees" ])
    }
    
    func test_path_can_be_on_both_side_of_operator() {
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(@.category == @.category)].author"), ["Nigel Rees", "Evelyn Waugh", "Herman Melville", "J. R. R. Tolkien"])
    }
    
    func test_patterns_can_be_evaluated() {
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(@.category =~ /reference/)].author"), ["Nigel Rees"])
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(/reference/ =~ @.category)].author"), ["Nigel Rees"])
    }
    
    func test_patterns_can_be_evaluated_with_ignore_case() {
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(@.category =~ /REFERENCE/)].author"), [])
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(@.category =~ /REFERENCE/i)].author"), ["Nigel Rees"])
    }
    
    func test_negate_exists_check() {
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(@.isbn)].author"), ["Herman Melville","J. R. R. Tolkien"])
        XCTAssertEqualAny(jsonDocument.query(values: "$.store.book[?(!@.isbn)].author"), ["Nigel Rees","Evelyn Waugh"])
    }

    func test_negate_exists_check_primitive() {
        let json = "[0,1,null,2,3]"
        XCTAssertEqualAny(json.query(values: "$[?(@)]"), [ 0, 1, nil, 2, 3 ])
        XCTAssertEqualAny(json.query(values: "$[?(@ != null)]"), [ 0, 1, 2, 3 ])
        XCTAssertEqualAny(json.query(values: "$[?(!@)]"), [ ])
    }
    
    func test_equality_check_does_not_break_evaluation() {
        XCTAssertEqualAny(#"[{"value":"5"}]"#.query(values: "$[?(@.value=='5')]")?.count, 1)
        XCTAssertEqualAny(#"[{"value":5}]"#.query(values: "$[?(@.value==5)]")?.count, 1)

        XCTAssertEqualAny(#"[{"value":"5.1.26"}]"#.query(values: "$[?(@.value=='5.1.26')]")?.count, 1)

        XCTAssertEqualAny(#"[{"value":"5"}]"#.query(values: "$[?(@.value=='5.1.26')]")?.count, 0)
        XCTAssertEqualAny(#"[{"value":5}]"#.query(values: "$[?(@.value=='5.1.26')]")?.count, 0)
        XCTAssertEqualAny(#"[{"value":5.1}]"#.query(values: "$[?(@.value=='5.1.26')]")?.count, 0)

        XCTAssertEqualAny(#"[{"value":"5.1.26"}]"#.query(values: "$[?(@.value=='5')]")?.count, 0)
        XCTAssertEqualAny(#"[{"value":"5.1.26"}]"#.query(values: "$[?(@.value==5)]")?.count, 0)
        XCTAssertEqualAny(#"[{"value":"5.1.26"}]"#.query(values: "$[?(@.value==5.1)]")?.count, 0)
    }
    
    func test_lt_check_does_not_break_evaluation() {
        XCTAssertEqualAny(#"[{"value":"5"}]"#.query(values: "$[?(@.value<'7')]")?.count, 1)
    
        XCTAssertEqualAny(#"[{"value":"7"}]"#.query(values: "$[?(@.value<'5')]")?.count, 0)
    
        XCTAssertEqualAny(#"[{"value":5}]"#.query(values: "$[?(@.value<7)]")?.count, 1)
        XCTAssertEqualAny(#"[{"value":7}]"#.query(values: "$[?(@.value<5)]")?.count, 0)
        
        XCTAssertEqualAny(#"[{"value":5}]"#.query(values: "$[?(@.value<7.1)]")?.count, 1)
        XCTAssertEqualAny(#"[{"value":7}]"#.query(values: "$[?(@.value<5.1)]")?.count, 0)
    
        XCTAssertEqualAny(#"[{"value":"5.1"}]"#.query(values: "$[?(@.value<7)]")?.count, 1)
        XCTAssertEqualAny(#"[{"value":"7.1"}]"#.query(values: "$[?(@.value<5)]")?.count, 0)
    }
    
    func test_escape_pattern() {
        XCTAssertEqualAny("[\"x\"]".query(values: "$[?(@ =~ /\\/|x/)]")?.count, 1)
    }
    
    func test_filter_evaluation_does_not_break_path_evaluation() {
        XCTAssertEqualAny("[{\"s\": \"fo\", \"expected_size\": \"m\"}, {\"s\": \"lo\", \"expected_size\": 2}]".query(values: "$[?(@.s size @.expected_size)]")?.count, 1)
    }
}

extension InlineFilterTest {
    static var allTests : [(String, (InlineFilterTest) -> () throws -> Void)] {
        return [
            ("test_root_context_can_be_referred_in_predicate", test_root_context_can_be_referred_in_predicate),
            ("test_multiple_context_object_can_be_refered", test_multiple_context_object_can_be_refered),
            ("test_simple_inline_or_statement_evaluates", test_simple_inline_or_statement_evaluates),
            ("test_no_path_ref_in_filter_hit_all", test_no_path_ref_in_filter_hit_all),
            ("test_no_path_ref_in_filter_hit_none", test_no_path_ref_in_filter_hit_none),
            ("test_path_can_be_on_either_side_of_operator", test_path_can_be_on_either_side_of_operator),
            ("test_path_can_be_on_both_side_of_operator", test_path_can_be_on_both_side_of_operator),
            ("test_patterns_can_be_evaluated", test_patterns_can_be_evaluated),
            ("test_patterns_can_be_evaluated_with_ignore_case", test_patterns_can_be_evaluated_with_ignore_case),
            ("test_negate_exists_check", test_negate_exists_check),
            ("test_negate_exists_check_primitive", test_negate_exists_check_primitive),
            ("test_equality_check_does_not_break_evaluation", test_equality_check_does_not_break_evaluation),
            ("test_lt_check_does_not_break_evaluation", test_lt_check_does_not_break_evaluation),
            ("test_escape_pattern", test_escape_pattern),
            ("test_filter_evaluation_does_not_break_path_evaluation", test_filter_evaluation_does_not_break_path_evaluation)
        ]
    }
}
