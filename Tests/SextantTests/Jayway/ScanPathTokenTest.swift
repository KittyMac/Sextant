import XCTest
import class Foundation.Bundle

import Sextant

class ScanPathTokenTests: TestsBase {
    let jsonDocument1 = """
        {
            "store": {
                "book": [
                    {
                        "category": "reference",
                        "author": "Nigel Rees",
                        "title": "Sayings of the Century",
                        "price": 8.95,
                        "address": {
                            "street": "fleet street",
                            "city": "London"
                        }
                    },
                    {
                        "category": "fiction",
                        "author": "Evelyn Waugh",
                        "title": "Sword of Honour",
                        "price": 12.9,
                        "address": {
                            "street": "Baker street",
                            "city": "London"
                        }
                    },
                    {
                        "category": "fiction",
                        "author": "J. R. R. Tolkien",
                        "title": "The Lord of the Rings",
                        "isbn": "0-395-19395-8",
                        "price": 22.99,
                        "address": {
                            "street": "Svea gatan",
                            "city": "Stockholm"
                        }
                    }
                ],
                "bicycle": {
                    "color": "red",
                    "price": 19.95,
                    "address": {
                        "street": "Söder gatan",
                        "city": "Stockholm"
                    },
                    "items": [
                        [
                            "A",
                            "B",
                            "C"
                        ],
                        1,
                        2,
                        3,
                        4,
                        5
                    ]
                }
            }
        }
    """
    
    let jsonDocument2 = """
       {
           "firstName": "John",
           "lastName": "doe",
           "age": 26,
           "address": {
               "streetAddress": "naist street",
               "city": "Nara",
               "postalCode": "630-0192"
           },
           "phoneNumbers": [
               {
                   "type": "iPhone",
                   "number": "0123-4567-8888"
               },
               {
                   "type": "home",
                   "number": "0123-4567-8910"
               }
           ]
       }
    """
    
    func test_a_document_can_be_scanned_for_property() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..author"), [
            "Nigel Rees", "Evelyn Waugh", "J. R. R. Tolkien"
        ])
        XCTAssertEqualAny(jsonDocument1.query(paths: "$..author"), [
            #"$['store']['book'][0]['author']"#,
            #"$['store']['book'][1]['author']"#,
            #"$['store']['book'][2]['author']"#
        ])
    }

    func test_a_document_can_be_scanned_for_property_path() {
        XCTAssertEqualAny(jsonDocument1.query(values: "$..address.street"), [
            "Söder gatan", "fleet street", "Baker street", "Svea gatan"
        ])
        XCTAssertEqualAny(jsonDocument1.query(paths: "$..address.street"), [
            #"$['store']['bicycle']['address']['street']"#,
            #"$['store']['book'][0]['address']['street']"#,
            #"$['store']['book'][1]['address']['street']"#,
            #"$['store']['book'][2]['address']['street']"#
        ])
    }
    
    func test_a_document_can_be_scanned_for_wildcard() {
        XCTAssertEqualAny(jsonDocument1.query(paths: "$..[*]"), [
            "$['store']",
            "$['store']['bicycle']",
            "$['store']['book']",
            "$['store']['bicycle']['address']",
            "$['store']['bicycle']['color']",
            "$['store']['bicycle']['price']",
            "$['store']['bicycle']['items']",
            "$['store']['bicycle']['address']['city']",
            "$['store']['bicycle']['address']['street']",
            "$['store']['bicycle']['items'][0]",
            "$['store']['bicycle']['items'][1]",
            "$['store']['bicycle']['items'][2]",
            "$['store']['bicycle']['items'][3]",
            "$['store']['bicycle']['items'][4]",
            "$['store']['bicycle']['items'][5]",
            "$['store']['bicycle']['items'][0][0]",
            "$['store']['bicycle']['items'][0][1]",
            "$['store']['bicycle']['items'][0][2]",
            "$['store']['book'][0]",
            "$['store']['book'][1]",
            "$['store']['book'][2]",
            "$['store']['book'][0]['address']",
            "$['store']['book'][0]['author']",
            "$['store']['book'][0]['price']",
            "$['store']['book'][0]['category']",
            "$['store']['book'][0]['title']",
            "$['store']['book'][0]['address']['city']",
            "$['store']['book'][0]['address']['street']",
            "$['store']['book'][1]['address']",
            "$['store']['book'][1]['author']",
            "$['store']['book'][1]['price']",
            "$['store']['book'][1]['category']",
            "$['store']['book'][1]['title']",
            "$['store']['book'][1]['address']['city']",
            "$['store']['book'][1]['address']['street']",
            "$['store']['book'][2]['address']",
            "$['store']['book'][2]['author']",
            "$['store']['book'][2]['price']",
            "$['store']['book'][2]['isbn']",
            "$['store']['book'][2]['category']",
            "$['store']['book'][2]['title']",
            "$['store']['book'][2]['address']['city']",
            "$['store']['book'][2]['address']['street']"
        ])
    }
    
    func test_a_document_can_be_scanned_for_wildcard2() {
        XCTAssertEqualAny(jsonDocument1.query(paths: "$.store.book[0]..*"), [
            "$['store']['book'][0]['address']",
            "$['store']['book'][0]['author']",
            "$['store']['book'][0]['price']",
            "$['store']['book'][0]['category']",
            "$['store']['book'][0]['title']",
            "$['store']['book'][0]['address']['city']",
            "$['store']['book'][0]['address']['street']"
        ])
    }
    
    func test_a_document_can_be_scanned_for_wildcard3() {
        XCTAssertEqualAny(jsonDocument2.query(paths: "$.phoneNumbers[0]..*"), [
            "$['phoneNumbers'][0]['number']",
            "$['phoneNumbers'][0]['type']"
        ])
    }
    
    func test_a_document_can_be_scanned_for_predicate_match() {
        XCTAssertEqualAny(jsonDocument1.query(paths: "$..[?(@.address.city == 'Stockholm')]"), [
            "$['store']['bicycle']",
            "$['store']['book'][2]"
        ])
    }
    
    func test_a_document_can_be_scanned_for_existence() {
        XCTAssertEqualAny(jsonDocument1.query(paths: "$..[?(@.isbn)]"), [
            "$['store']['book'][2]"
        ])
    }

}

/*












@end


NS_ASSUME_NONNULL_END
*/
