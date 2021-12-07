import XCTest
import class Foundation.Bundle

import Sextant

class PredicatePathTokenTests: TestsBase {
    let jsonArray2 = """
        [
            {
                "foo": "foo-val-0",
                "int": 0,
                "decimal": 0.0
            },
            {
                "foo": "foo-val-1",
                "int": 1,
                "decimal": 0.1
            },
            {
                "foo": "foo-val-2",
                "int": 2,
                "decimal": 0.2
            },
            {
                "foo": "foo-val-3",
                "int": 3,
                "decimal": 0.3
            },
            {
                "foo": "foo-val-4",
                "int": 4,
                "decimal": 0.4
            },
            {
                "foo": "foo-val-5",
                "int": 5,
                "decimal": 0.5
            },
            {
                "foo": "foo-val-6",
                "int": 6,
                "decimal": 0.6
            },
            {
                "foo": "foo-val-7",
                "int": 7,
                "decimal": 0.7,
                "bool": true
            }
        ]
    """

    func test_a_filter_predicate_can_be_evaluated_on_string_criteria() {
        XCTAssertEqualAny(jsonArray2.query(values: "$[?(@.foo == 'foo-val-1')]"), [
            [
                "foo": "foo-val-1",
                "int": 1,
                "decimal": 0.1
            ]
        ])
    }

    func test_a_filter_predicate_can_be_evaluated_on_int_criteria() {
        XCTAssertEqualAny(jsonArray2.query(values: "$[?(@.int == 1)]"), [
            [
                "foo": "foo-val-1",
                "int": 1,
                "decimal": 0.1
            ]
        ])
    }

    func test_a_filter_predicate_can_be_evaluated_on_decimal_criteria() {
        XCTAssertEqualAny(jsonArray2.query(values: "$[?(@.int == 1)]"), [
            [
                "foo": "foo-val-1",
                "int": 1,
                "decimal": 0.1
            ]
        ])
    }

    func test_multiple_criteria_can_be_used() {
        XCTAssertEqualAny(jsonArray2.query(values: "$[?(@.decimal == 0.1 && @.int == 1)]"), [
            [
                "foo": "foo-val-1",
                "int": 1,
                "decimal": 0.1
            ]
        ])
    }

    func test_field_existence_can_be_checked() {
        XCTAssertEqualAny(jsonArray2.query(values: "$[?(@.bool)]"), [
            [
                "foo": "foo-val-7",
                "int": 7,
                "decimal": 0.7,
                "bool": true
            ]
        ])
    }

    func test_boolean_criteria_evaluates() {
        XCTAssertEqualAny(jsonArray2.query(values: "$[?(@.bool == true)]"), [
            [
                "foo": "foo-val-7",
                "int": 7,
                "decimal": 0.7,
                "bool": true
            ]
        ])
    }
}

