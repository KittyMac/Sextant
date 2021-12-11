import XCTest
import class Foundation.Bundle

@testable import Sextant

class FilterTest: TestsBase {
    let jsonObject = """
        {
            "int-key": 1,
            "long-key": 3000000000,
            "double-key": 10.1,
            "boolean-key": true,
            "null-key": null,
            "string-key": "string",
            "string-key-empty": "",
            "char-key": "c",
            "arr-empty": [

            ],
            "int-arr": [
                0,
                1,
                2,
                3,
                4
            ],
            "string-arr": [
                "a",
                "b",
                "c",
                "d",
                "e"
            ]
        }
    """
    
    // MARK - SMJFilterTest - EQ

    func test_int_eq_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key == 1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key == 666)]")?.count, 0)
    }
    
    func test_int_eq_string_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key == '1')]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key == '666')]")?.count, 0)

        XCTAssertEqual(jsonObject.query(values: "[?(1 == '1')]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?('1' == 1)]")?.count, 1)
        
        XCTAssertEqual(jsonObject.query(values: "[?(1 === '1')]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?('1' === 1)]")?.count, 0)

        XCTAssertEqual(jsonObject.query(values: "[?(1 === 1)]")?.count, 1)
    }

    func test_long_eq_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key == 3000000000)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key == 666)]")?.count, 0)
    }

    func test_double_eq_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key == 10.1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key == 10.10)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key == 10.11)]")?.count, 0)
    }

    func test_string_eq_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key == 'string')]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key == '666')]")?.count, 0)
    }

    func test_boolean_eq_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.boolean-key == true)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.boolean-key == false)]")?.count, 0)
    }

    func test_null_eq_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key == null)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key == '666')]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key == null)]")?.count, 0)
    }

    func test_arr_eq_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.arr-empty == [])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr == [0,1,2,3,4])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr == [0,1,2,3])]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr == [0,1,2,3,4,5])]")?.count, 0)
    }
    
    // MARK - SMJFilterTest - NE

    func test_int_ne_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key != 1)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key != 666)]")?.count, 1)
    }

    func test_long_ne_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key != 3000000000)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key != 666)]")?.count, 1)
    }

    func test_double_ne_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key != 10.1)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key != 10.10)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key != 10.11)]")?.count, 1)
    }

    func test_string_ne_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key != 'string')]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key != '666')]")?.count, 1)
    }

    func test_boolean_ne_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.boolean-key != true)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.boolean-key != false)]")?.count, 1)
    }

    func test_null_ne_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key != null)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key != '666')]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key != null)]")?.count, 1)
    }


    // MARK - SMJFilterTest - LT

    func test_int_lt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key < 10)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key < 0)]")?.count, 0)
    }

    func test_long_lt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key < 4000000000)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key < 666)]")?.count, 0)
    }

    func test_double_lt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key < 100.1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key < 1.1)]")?.count, 0)
    }

    func test_string_lt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.char-key < 'x')]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.char-key < 'a')]")?.count, 0)
    }

    // MARK - SMJFilterTest - LTE

    func test_int_lte_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key <= 10)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key <= 1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key <= 0)]")?.count, 0)
    }

    func test_long_lte_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key <= 4000000000)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key <= 3000000000)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key <= 666)]")?.count, 0)
    }

    func test_double_lte_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key <= 100.1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key <= 10.1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key <= 1.1)]")?.count, 0)
    }

    // MARK - SMJFilterTest - GT

    func test_int_gt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key > 10)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key > 0)]")?.count, 1)
    }

    func test_long_gt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key > 4000000000)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key > 666)]")?.count, 1)
    }

    func test_double_gt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key > 100.1)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key > 1.1)]")?.count, 1)
    }

    func test_string_gt_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.char-key > 'x')]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.char-key > 'a')]")?.count, 1)
    }

    // MARK - SMJFilterTest - GTE

    func test_int_gte_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key >= 10)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key >= 1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key >= 0)]")?.count, 1)
    }

    func test_long_gte_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key >= 4000000000)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key >= 3000000000)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.long-key >= 666)]")?.count, 1)
    }

    func test_double_gte_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key >= 100.1)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key >= 10.1)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.double-key >= 1.1)]")?.count, 1)
    }

    // MARK - SMJFilterTest - Regex

    func test_string_regex_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key =~ /^string$/)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key =~ /^tring$/)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key =~ /^string$/)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key =~ /^string$/)]")?.count, 0)
    }

    // MARK - SMJFilterTest - JSON equality

    func test_json_evals() {
        let json = "{\"foo\": [1,2], \"bar\": {\"a\":true}}"
        XCTAssertEqual(json.query(values: "[?(@.foo == [1,2])]")?.count, 1)
    }

    // MARK - SMJFilterTest - IN

    func test_string_in_evals() {
        //XCTAssertEqual(jsonObject.query(values: "[?(@.string-key IN [\"a\", null, \"string\"])]")?.count, 1)
        //XCTAssertEqual(jsonObject.query(values: "[?(@.string-key IN [\"a\", null])]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key IN [\"a\", null])]")?.count, 1)
        //XCTAssertEqual(jsonObject.query(values: "[?(@.null-key IN [\"a\", \"b\"])]")?.count, 0)
        //XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr IN [\"a\"])]")?.count, 0)
    }

    // MARK - SMJFilterTest - NIN

    func test_string_nin_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key NIN [\"a\", null, \"string\"])]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key NIN [\"a\", null])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key NIN [\"a\", null])]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key NIN [\"a\", \"b\"])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr NIN [\"a\"])]")?.count, 1)
    }

    // MARK - SMJFilterTest - ALL

    func test_int_all_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr ALL [0, 1])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr ALL [0, 7])]")?.count, 0)
    }

    func test_string_all_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr ALL [\"a\",\"b\"])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr ALL [\"a\",\"x\"])]")?.count, 0)
    }

    func test_not_array_all_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key ALL [\"a\",\"b\"])]")?.count, 0)
    }

    // MARK - SMJFilterTest - SIZE

    func test_array_size_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr SIZE 5)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr SIZE 7)]")?.count, 0)
    }

    func test_string_size_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key SIZE 6)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key SIZE 7)]")?.count, 0)
    }

    func test_other_size_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key SIZE 6)]")?.count, 0)
    }

    func test_null_size_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key SIZE 6)]")?.count, 0)
    }

    // MARK - SMJFilterTest - SUBSETOF

    func test_array_subsetof_evals() {
        XCTAssertEqual(jsonObject.query(values: #"[?(@.string-arr SUBSETOF [ "a", "b", "c", "d", "e", "f", "g" ])]"#)?.count, 1)
        XCTAssertEqual(jsonObject.query(values: #"[?(@.string-arr SUBSETOF [ "e", "d", "b", "c", "a" ])]"#)?.count, 1)
        XCTAssertEqual(jsonObject.query(values: #"[?(@.string-arr SUBSETOF [ "a", "b", "c", "d" ])]"#)?.count, 0)
    }

    // MARK - SMJFilterTest - ANYOF

    func test_array_anyof_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr ANYOF [ \"a\", \"z\" ])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr ANYOF [ \"z\", \"b\", \"a\" ])]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr ANYOF [ \"x\", \"y\", \"z\" ])]")?.count, 0)
    }

    // MARK - SMJFilterTest - NONEOF

    func test_array_noneof_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr NONEOF [ \"a\", \"z\" ])]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr NONEOF [ \"z\", \"b\", \"a\" ])]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-arr NONEOF [ \"x\", \"y\", \"z\" ])]")?.count, 1)
    }

    // MARK - SMJFilterTest - EXISTS

    func test_exists_evals() {
        // SourceMac-Note: we support the "EXISTS" token, event if it's similar (and so redoundant) to don't use operator and right value.

        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key EXISTS true)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key EXISTS false)]")?.count, 0)
        
        XCTAssertEqual(jsonObject.query(values: "[?(@.missing-key EXISTS true)]")?.count, 0)
        XCTAssertEqualAny(jsonObject.query(values: "[?(@.missing-key EXISTS false)]")?.count, 1)
    }

    // MARK - SMJFilterTest - TYPE

    func test_type_evals() {
        //XCTAssertEqual(jsonObject.query(values: "[?(@.string-key TYPE 'string')]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key TYPE 'number')]")?.count, 0)

        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key TYPE 'string')]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-key TYPE 'number')]")?.count, 1)
        
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr TYPE 'json')]")?.count, 1)

        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key TYPE @.string-key)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key TYPE @.int-key)]")?.count, 0)
    }

    // MARK - SMJFilterTest - EMPTY

    func test_empty_evals() {
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key EMPTY false)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key EMPTY true)]")?.count, 0)

        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key-empty EMPTY true)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.string-key-empty EMPTY false)]")?.count, 0)
        
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr EMPTY false)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.int-arr EMPTY true)]")?.count, 0)

        XCTAssertEqual(jsonObject.query(values: "[?(@.arr-empty EMPTY true)]")?.count, 1)
        XCTAssertEqual(jsonObject.query(values: "[?(@.arr-empty EMPTY false)]")?.count, 0)

        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key EMPTY true)]")?.count, 0)
        XCTAssertEqual(jsonObject.query(values: "[?(@.null-key EMPTY false)]")?.count, 0)
    }

    // MARK - SMJFilterTest - OR

    func test_or_and_filters_evaluates() {
        let json = """
            {
                "foo": true,
                "bar": false
            }
        """
        XCTAssertEqual(json.query(values: "[?(@.foo == true || @.bar == true)]")?.count, 1)
        XCTAssertEqual(json.query(values: "[?(@.foo == true && @.bar == true)]")?.count, 0)
    }

    func testFilterWithOrShortCircuit1() {
        let json = "{\"firstname\":\"Bob\",\"surname\":\"Smith\",\"age\":30}"
        XCTAssertEqual(json.query(values: "[?((@.firstname == 'Bob' || @.firstname == 'Jane') && @.surname == 'Doe')]")?.count, 0)
    }

    func testFilterWithOrShortCircuit2() {
        let json = "{\"firstname\":\"Bob\",\"surname\":\"Smith\",\"age\":30}"
        XCTAssertEqual(json.query(values: "[?((@.firstname == 'Bob' || @.firstname == 'Jane') && @.surname == 'Smith')]")?.count, 1)
    }


    // MARK - SMJFilterTest - Others

    func test_inline_in_criteria_evaluates() {
        XCTAssertEqual(jsonDocument.query(values: #"$.store.book[?(@.category in ["reference", "fiction"])]"#)?.count, 4)
    }
}


extension FilterTest {
    static var allTests : [(String, (FilterTest) -> () throws -> Void)] {
        return [
            ("test_int_eq_evals", test_int_eq_evals),
            ("test_int_eq_string_evals", test_int_eq_string_evals),
            ("test_long_eq_evals", test_long_eq_evals),
            ("test_double_eq_evals", test_double_eq_evals),
            ("test_string_eq_evals", test_string_eq_evals),
            ("test_boolean_eq_evals", test_boolean_eq_evals),
            ("test_null_eq_evals", test_null_eq_evals),
            ("test_arr_eq_evals", test_arr_eq_evals),
            ("test_int_ne_evals", test_int_ne_evals),
            ("test_long_ne_evals", test_long_ne_evals),
            ("test_double_ne_evals", test_double_ne_evals),
            ("test_string_ne_evals", test_string_ne_evals),
            ("test_boolean_ne_evals", test_boolean_ne_evals),
            ("test_null_ne_evals", test_null_ne_evals),
            ("test_int_lt_evals", test_int_lt_evals),
            ("test_long_lt_evals", test_long_lt_evals),
            ("test_double_lt_evals", test_double_lt_evals),
            ("test_string_lt_evals", test_string_lt_evals),
            ("test_int_lte_evals", test_int_lte_evals),
            ("test_long_lte_evals", test_long_lte_evals),
            ("test_double_lte_evals", test_double_lte_evals),
            ("test_int_gt_evals", test_int_gt_evals),
            ("test_long_gt_evals", test_long_gt_evals),
            ("test_double_gt_evals", test_double_gt_evals),
            ("test_string_gt_evals", test_string_gt_evals),
            ("test_int_gte_evals", test_int_gte_evals),
            ("test_long_gte_evals", test_long_gte_evals),
            ("test_double_gte_evals", test_double_gte_evals),
            ("test_string_regex_evals", test_string_regex_evals),
            ("test_json_evals", test_json_evals),
            ("test_string_in_evals", test_string_in_evals),
            ("test_string_nin_evals", test_string_nin_evals),
            ("test_int_all_evals", test_int_all_evals),
            ("test_string_all_evals", test_string_all_evals),
            ("test_not_array_all_evals", test_not_array_all_evals),
            ("test_array_size_evals", test_array_size_evals),
            ("test_string_size_evals", test_string_size_evals),
            ("test_other_size_evals", test_other_size_evals),
            ("test_null_size_evals", test_null_size_evals),
            ("test_array_subsetof_evals", test_array_subsetof_evals),
            ("test_array_anyof_evals", test_array_anyof_evals),
            ("test_array_noneof_evals", test_array_noneof_evals),
            ("test_exists_evals", test_exists_evals),
            ("test_type_evals", test_type_evals),
            ("test_empty_evals", test_empty_evals),
            ("test_or_and_filters_evaluates", test_or_and_filters_evaluates),
            ("testFilterWithOrShortCircuit1", testFilterWithOrShortCircuit1),
            ("testFilterWithOrShortCircuit2", testFilterWithOrShortCircuit2),
            ("test_inline_in_criteria_evaluates", test_inline_in_criteria_evaluates),
        ]
    }
}
