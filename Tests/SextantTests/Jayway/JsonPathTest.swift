import XCTest
import class Foundation.Bundle

@testable import Sextant

class JsonPathTest: TestsBase {
    let jsonArray = """
        [
            {
                "value": 1
            },
            {
                "value": 2
            },
            {
                "value": 3
            },
            {
                "value": 4
            }
        ]
    """
    
    let jsonDocument1 = """
        {
            "store": {
                "book": [
                    {
                        "category": "reference",
                        "author": "Nigel Rees",
                        "title": "Sayings of the Century",
                        "display-price": 8.95
                    },
                    {
                        "category": "fiction",
                        "author": "Evelyn Waugh",
                        "title": "Sword of Honour",
                        "display-price": 12.99
                    },
                    {
                        "category": "fiction",
                        "author": "Herman Melville",
                        "title": "Moby Dick",
                        "isbn": "0-553-21311-3",
                        "display-price": 8.99
                    },
                    {
                        "category": "fiction",
                        "author": "J. R. R. Tolkien",
                        "title": "The Lord of the Rings",
                        "isbn": "0-395-19395-8",
                        "display-price": 22.99
                    }
                ],
                "bicycle": {
                    "color": "red",
                    "display-price": 19.95,
                    "foo:bar": "fooBar",
                    "dot.notation": "new",
                    "dash-notation": "dashes"
                }
            }
        }
    """
    
    let jsonProduct = """
        {
            "product": [
                {
                    "version": "A",
                    "codename": "Seattle",
                    "attr.with.dot": "A"
                },
                {
                    "version": "4.0",
                    "codename": "Montreal",
                    "attr.with.dot": "B"
                }
            ]
        }
    """
    
    let jsonArrayExpand = """
        [
            {
                "parent": "ONE",
                "child": {
                    "name": "NAME_ONE"
                }
            },
            [
                {
                    "parent": "TWO",
                    "child": {
                        "name": "NAME_TWO"
                    }
                }
            ]
        ]
    """
    
    func test_missing_prop() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[*].fooBar.not"), [])
    }
    
    func test_bracket_notation_with_dots() {
        let json = """
            {
                "store": {
                    "book": [
                        {
                            "author.name": "Nigel Rees",
                            "category": "reference",
                            "price": 8.95,
                            "title": "Sayings of the Century"
                        }
                    ]
                }
            }
        """
        XCTAssertEqualAny(json.query(values: "$.store.book[0]['author.name']"), ["Nigel Rees"])
    }
    
    func test_null_object_in_path() {
        let json = """
            {
                "success": true,
                "data": {
                    "user": 3,
                    "own": null,
                    "passes": null,
                    "completed": null
                },
                "data2": {
                    "user": 3,
                    "own": null,
                    "passes": [
                        {
                            "id": "1"
                        }
                    ],
                    "completed": null
                },
                "version": 1371160528774
            }
        """
        
        XCTAssertEqualAny(json.query(values: "$.data.passes[0].id"), [])
        XCTAssertEqualAny(json.query(values: "$.data2.passes[0].id"), ["1"])
    }
    
    func test_array_start_expands() {
        XCTAssertEqualAny(jsonArrayExpand.query(values: "$[?(@['parent'] == 'ONE')].child.name"), ["NAME_ONE"])
    }
    
    func test_bracket_notation_can_be_used_in_path() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.['store'].bicycle.['dot.notation']"), ["new"])
        
        XCTAssertEqualAny(jsonDocument1.query(values: "$['store']['bicycle']['dot.notation']"), ["new"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.['store']['bicycle']['dot.notation']"), ["new"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.['store'].['bicycle'].['dot.notation']"), ["new"])
        
        XCTAssertEqualAny(jsonDocument1.query(values: "$.['store'].bicycle.['dash-notation']"), ["dashes"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$['store']['bicycle']['dash-notation']"), ["dashes"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.['store']['bicycle']['dash-notation']"), ["dashes"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.['store'].['bicycle'].['dash-notation']"), ["dashes"])

    }
    
    func test_filter_an_array() {
        XCTAssertEqualAny(jsonArray.query(values: "$.[?(@.value == 1)]")?.count, 1)
    }
    
    func test_filter_an_array_on_index() {
        XCTAssertEqualAny(jsonArray.query(values: "$.[1].value"), [2])
    }
    
    func test_read_path_with_colon() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$['store']['bicycle']['foo:bar']"), ["fooBar"])
    }
    
    func test_read_document_from_root() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store")?.count, 1)
    }
    
    func test_read_store_book_1() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[1]"), [[
            "category": "fiction",
            "author": "Evelyn Waugh",
            "title": "Sword of Honour",
            "display-price": 12.99
        ]])
    }
    
    func test_read_store_book_wildcard() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[*]")?.count, 4)
    }
    
    func test_read_store_book_author() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[0,1].author"), ["Nigel Rees", "Evelyn Waugh"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[*].author"), ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.['store'].['book'][*].['author']"), ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$['store']['book'][*]['author']"), ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$['store'].book[*]['author']"), ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"])
    }
    
    func test_all_authors() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..author"), ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"])
    }
    
    func test_all_store_properties() {
        XCTAssertEqualAny(jsonDocument1.query(paths: "$.store.*"), [
            "$['store']['bicycle']",
            "$['store']['book']"
        ])
    }
    
    func test_all_prices_in_store() {
        guard let values = jsonDocument1.query(values: "$.store..['display-price']") else { return XCTAssert(false) }
        XCTAssertEqualAny(values.compactMap { $0 as? Double }.sorted(), [8.95, 8.99, 12.99, 19.95, 22.99])
    }
    
    func test_access_array_by_index_from_tail() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..book[1:].author"), ["Evelyn Waugh","Herman Melville","J. R. R. Tolkien"])
    }
    
    func test_read_store_book_index_0_and_1() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[0,1].author"), ["Nigel Rees", "Evelyn Waugh"])
    }
    
    func test_read_store_book_pull_first_2() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[:2].author"), ["Nigel Rees", "Evelyn Waugh"])
    }
    
    func test_read_store_book_filter_by_isbn() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[?(@.isbn)].isbn"), ["0-553-21311-3", "0-395-19395-8"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[?(@['isbn'])].isbn")?.count, 2)
    }
    
    func test_all_books_cheaper_than_10() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..book[?(@['display-price'] < 10)].title"), ["Sayings of the Century", "Moby Dick"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$..book[?(@.display-price < 10)].title"), ["Sayings of the Century", "Moby Dick"])
    }
    
    func test_all_books() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..book")?.count, 1)
    }
    
    func test_dot_in_predicate_works() {
        XCTAssertEqualAny(jsonProduct.query(values: "$.product[?(@.version=='4.0')].codename"), ["Montreal"])
    }
    
    func test_dots_in_predicate_works() {
        XCTAssertEqualAny(jsonProduct.query(values: "$.product[?(@['attr.with.dot']=='A')].codename"), ["Seattle"])
    }
    
    func test_all_books_with_category_reference() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..book[?(@.category=='reference')].title"), ["Sayings of the Century"])
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[?(@.category=='reference')].title"), ["Sayings of the Century"])
    }
    
    func test_all_members_of_all_documents() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..*")?.count, 30)
    }
    
    func test_access_index_out_of_bounds_does_not_throw_exception() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$.store.book[100].author"), [])
    }
    
    func test_exists_filter_with_nested_path() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..[?(@.bicycle.color)]")?.count, 1)
        XCTAssertEqualAny(jsonDocument1.query(values: "$..[?(@.bicycle.numberOfGears)]")?.count, 0)
    }
    
    func test_prevent_stack_overflow_error_when_unclosed_property() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$['boo','foo][?(@ =~ /bar/)]"), nil)
    }
}

extension JsonPathTest {
    static var allTests : [(String, (JsonPathTest) -> () throws -> Void)] {
        return [
            ("test_missing_prop", test_missing_prop),
            ("test_bracket_notation_with_dots", test_bracket_notation_with_dots),
            ("test_null_object_in_path", test_null_object_in_path),
            ("test_array_start_expands", test_array_start_expands),
            ("test_bracket_notation_can_be_used_in_path", test_bracket_notation_can_be_used_in_path),
            ("test_filter_an_array", test_filter_an_array),
            ("test_filter_an_array_on_index", test_filter_an_array_on_index),
            ("test_read_path_with_colon", test_read_path_with_colon),
            ("test_read_document_from_root", test_read_document_from_root),
            ("test_read_store_book_1", test_read_store_book_1),
            ("test_read_store_book_wildcard", test_read_store_book_wildcard),
            ("test_read_store_book_author", test_read_store_book_author),
            ("test_all_authors", test_all_authors),
            ("test_all_store_properties", test_all_store_properties),
            ("test_all_prices_in_store", test_all_prices_in_store),
            ("test_access_array_by_index_from_tail", test_access_array_by_index_from_tail),
            ("test_read_store_book_index_0_and_1", test_read_store_book_index_0_and_1),
            ("test_read_store_book_pull_first_2", test_read_store_book_pull_first_2),
            ("test_read_store_book_filter_by_isbn", test_read_store_book_filter_by_isbn),
            ("test_all_books_cheaper_than_10", test_all_books_cheaper_than_10),
            ("test_all_books", test_all_books),
            ("test_dot_in_predicate_works", test_dot_in_predicate_works),
            ("test_dots_in_predicate_works", test_dots_in_predicate_works),
            ("test_all_books_with_category_reference", test_all_books_with_category_reference),
            ("test_all_members_of_all_documents", test_all_members_of_all_documents),
            ("test_access_index_out_of_bounds_does_not_throw_exception", test_access_index_out_of_bounds_does_not_throw_exception),
            ("test_exists_filter_with_nested_path", test_exists_filter_with_nested_path),
            ("test_prevent_stack_overflow_error_when_unclosed_property", test_prevent_stack_overflow_error_when_unclosed_property)
        ]
    }
}
