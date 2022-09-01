import XCTest
import Hitch
import class Foundation.Bundle

import Sextant

class UpdateTest: TestsBase {
    
    func test_replace_index_in_array() {
        let json = #"["Hello","World"]"#
        
        json.query(replace: "$[0]", with: "Goodbye") { root in
            XCTAssertEqual(root.description, #"["Goodbye","World"]"#)
        }
        
        json.query(replace: [
            "$[0]",
            "$[1]"
        ], with: "Goodbye") { root in
            XCTAssertEqual(root.description, #"["Goodbye","Goodbye"]"#)
        }
        
        json.parsed { root in
            guard let root = root else { XCTFail(); return }
            root.query(replace: "$[0]", with: "Goodbye")
            root.query(replace: "$[1]", with: "Moon")
            XCTAssertEqual(root.description, #"["Goodbye","Moon"]"#)
        }
    }
    
    func test_foreach_index_in_array() {
        let json = #"[0,1,2,3,4,5,6,7,8,9]"#
        
        var total = 0
        json.query(forEach: "$[*]") { total += $0.intValue ?? 0 }
        XCTAssertEqual(total, 45)
        
        let json2 = #"["John","Jackie","Jason"]"#
        json2.parsed { root in
            guard let root = root else { XCTFail(); return }
            root.query(forEach: "$[*]") { $0.hitchValue = $0.hitchValue?.lowercase() }
            XCTAssertEqual(root.description, #"["john","jackie","jason"]"#)
            root.query(forEach: "$[*]") { $0.hitchValue = $0.hitchValue?.uppercase() }
            XCTAssertEqual(root.description, #"["JOHN","JACKIE","JASON"]"#)
        }
    }
    
    func test_filter_index_in_array() {
        let json = #"["Hello","World"]"#
        
        json.query(filter: "$[0]", { $0.halfHitchValue == "Goodbye" }) { root in
            XCTAssertEqual(root.description, #"["World"]"#)
        }
    }
    
    func test_an_array_child_property_can_be_updated() {
        jsonDocument.query(replace: "$.store.book[*].display-price", with: 1) { root in
            guard let results = root.query(values: "$.store.book[*].display-price") else { XCTFail(); return }
            XCTAssertEqualAny(results, [1, 1, 1, 1])
        }
    }
    
    func test_an_root_property_can_be_updated() {
        jsonDocument.query(replace: "$.int-max-property", with: 1) { root in
            guard let results = root.query(values: "$.int-max-property") else { XCTFail(); return }
            XCTAssertEqualAny(results, [1])
        }
    }
    
    func test_an_deep_scan_can_update() {
        jsonDocument.query(replace: "$..display-price", with: 1) { root in
            guard let results = root.query(values: "$..display-price") else { XCTFail(); return }
            XCTAssertEqualAny(results, [1, 1, 1, 1, 1])
        }
    }
    
    func test_an_filter_can_update() {
        jsonDocument.query(replace: "$.store.book[?(@.display-price)].display-price", with: 1) { root in
            guard let results = root.query(values: "$.store.book[?(@.display-price)].display-price") else { XCTFail(); return }
            XCTAssertEqualAny(results, [1, 1, 1, 1])
        }
    }
    
    func test_a_path_can_be_deleted() {
        jsonDocument.query(remove: "$.store.book[*].display-price") { root in
            guard let results = root.query(values: "$.store.book[*].display-price") else { XCTFail(); return }
            XCTAssertEqualAny(results, [])
        }
    }
    
    func test_an_array_can_be_updated() {
        let json = #"[0,1,2,3]"#
        
        let modifiedJson: String? = json.query(replace: "$[?(@ == 1)]", with: 9) { root in
            guard let results = root.query(values: "$[*]") else { XCTFail(); return nil }
            XCTAssertEqualAny(results, [0, 9, 2, 3])
            return root.description
        }
        
        XCTAssertEqual(modifiedJson, #"[0,9,2,3]"#)
    }
    
    func test_an_array_index_can_be_updated() {
        jsonDocument.query(replace: "$.store.book[0]", with: "a") { root in
            guard let results = root.query(values: "$.store.book[0]") else { XCTFail(); return }
            XCTAssertEqualAny(results, ["a"])
        }
    }
    
    func test_an_array_slice_can_be_updated() {
        jsonDocument.query(replace: "$.store.book[0:2]", with: "a") { root in
            guard let results = root.query(values: "$.store.book[0:2]") else { XCTFail(); return }
            XCTAssertEqualAny(results, ["a", "a"])
        }
    }
    
    func test_an_array_criteria_can_be_updated() {
        jsonDocument.query(replace: "$.store.book[?(@.category == 'fiction')]", with: "a") { root in
            guard let results = root.query(values: "$.store.book[?(@ == 'a')]") else { XCTFail(); return }
            XCTAssertEqualAny(results, ["a", "a", "a"])
        }
    }
    
    func test_an_array_criteria_can_be_deleted() {
        jsonDocument.query(remove: "$.store.book[?(@.category == 'fiction')]") { root in
            guard let results = root.query(values: "$.store.book[*].category") else { XCTFail(); return }
            XCTAssertEqualAny(results, ["reference"])
        }
    }
    
    func test_multi_prop_delete() {
        jsonDocument.query(remove: "$.store.book[*]['author','category']") { root in
            guard let results = root.query(values: "$.store.book[*]['author','category','display-price']]") else { XCTFail(); return }
            XCTAssertEqualAny(results, [8.95,12.99,8.99,22.99])
        }
    }
    
    func test_multi_prop_update_not_all_defined() {
        jsonDocument.query(replace: "$.store.book[*]['author', 'isbn']", with: "a") { root in
            guard let results = root.query(values: "$.store.book[*]['author', 'isbn']") else { XCTFail(); return }
            XCTAssertEqualAny(results, ["a", "a", "a", "a", "a", "a"])
        }
    }
    
    func test_add_to_array() {
        jsonDocument.query(forEach: "$.store.book", { $0.append(value: 1)  }) { root in
            guard let results = root.query(values: "$.store.book[4]") else { XCTFail(); return }
            XCTAssertEqualAny(results, [1])
        }
    }
    
    func test_add_to_object() {
        jsonDocument.query(forEach: "$.store.book[0]", { $0.set(key: "new-key", value: "new-value")  }) { root in
            guard let results = root.query(values: "$.store.book[0].new-key") else { XCTFail(); return }
            XCTAssertEqualAny(results, ["new-value"])
        }
    }
    
    func test_item_can_be_added_to_root_array() {
        let json = #"[1,2]"#
        json.query(forEach: "$", { $0.append(value: 3) }) { root in
            guard let results = root.query(values: "$") else { XCTFail(); return }
            XCTAssertEqualAny(results, [[1, 2, 3]])
        }
    }
    
    func test_key_val_can_be_added_to_root_object() {
        let json = #"{"a":"a-val"}"#
        json.query(forEach: "$", { $0.set(key: "new-key", value: "new-value") }) { root in
            guard let results = root.query(values: "$.new-key") else { XCTFail(); return }
            XCTAssertEqualAny(results, ["new-value"])
        }
    }
    
    func test_add_to_object_on_array() {
        jsonDocument.query(forEach: "$.store.book", { $0.set(key: "new-key", value: "new-value")  }) { root in
            guard let results = root.query(values: "$.store.book.new-key") else { XCTFail(); return }
            XCTAssertEqualAny(results, [])
        }
    }
    
    func test_add_to_array_on_object() {
        jsonDocument.query(forEach: "$.store.book[0]", { $0.append(value: "new-value")  }) { root in
            guard let results = root.query(values: "$.store.book[0]") else { XCTFail(); return }
            XCTAssertEqualAny(results, [
                [
                    "author": "Nigel Rees",
                    "title": "Sayings of the Century",
                    "display-price": 8.95,
                    "category": "reference"
                ]
            ])
        }
    }
    
    func test_root_object_can_be_updated() {
        let json = #"{"a":"a-val"}"#
        json.query(replace: "$[?(@.a == 'a-val')]", with: 1) { root in
            guard let results = root.query(values: "$") else { XCTFail(); return }
            XCTAssertEqualAny(results, [1])
        }
    }
    
    func test_a_path_can_be_renamed() {
        jsonDocument.query(forEach: "$.store", { store in
            store.rename(key: "book", with: "updated-book")
        }) { root in
            XCTAssertEqual(root.query(values: "$.store.book[*]")?.count, 0)
            XCTAssertEqual(root.query(values: "$.store.updated-book[*]")?.count, 4)
        }
    }
    
    func test_keys_in_root_containing_map_can_be_renamed() {
        jsonDocument.query(forEach: "$", { $0.rename(key: "store", with: "new-store") }) { root in
            XCTAssertEqual(root.query(values: "$.store[*]")?.count, 0)
            XCTAssertEqual(root.query(values: "$.new-store[*]")?.count, 2)
        }
    }
    
    func test_map_array_items_can_be_renamed() {
        jsonDocument.query(forEach: "$.store.book[*]", { $0.rename(key: "category", with: "renamed-category") }) { root in
            XCTAssertEqual(root.query(values: "$.store.book[*].category")?.count, 0)
            XCTAssertEqual(root.query(values: "$.store.book[*].renamed-category")?.count, 4)
        }
    }
    
    func test_non_map_array_items_cannot_be_renamed() {
        let json = #"[1,2]"#
        json.query(forEach: "$[*]", { $0.rename(key: "oldKey", with: "newKey") }) { root in
            XCTAssertEqualAny(root.query(values: "$"), [[1,2]])
        }
    }
    
    func test_multiple_properties_cannot_be_renamed() {
        XCTAssertEqual(jsonDocument.query(values: "$.store.book[*]['author', 'category']")?.count, 8)
        jsonDocument.query(forEach: "$.store.book[*]['author', 'category']", { $0.rename(key: "old-key", with: "new-key") }) { root in
            XCTAssertEqual(root.query(values: "$.store.book[*]['author', 'category']")?.count, 8)
        }
    }
    
    func test_root_can_be_mapped() {
        jsonDocument.query(map: "$", { _ in 1 }) { root in
            XCTAssertEqualAny(root.query(values: "$"), [1])
        }
    }
    
    func test_single_match_value_can_be_mapped() {
        jsonDocument.query(map: "$.string-property", { ($0.stringValue ?? "") +  "Converted" } ) { root in
            XCTAssertEqualAny(root.query(values: "$.string-property"), ["string-valueConverted"])
        }
    }
    
    func test_object_can_be_mapped() {
        jsonDocument.query(map: "$..book", { $0.description +  "Converted" } ) { root in
            guard let string: String = root.query("$..book") else { XCTFail(); return }
            XCTAssertTrue(string.hasSuffix("Converted"))
        }
    }
    
    func test_multi_match_path_can_be_mapped() {
        jsonDocument.query(map: "$..display-price", { $0.description +  "Converted" } ) { root in
            XCTAssertEqualAny(root.query(values: "$..display-price"), ["8.95Converted", "12.99Converted", "8.99Converted", "22.99Converted", "19.95Converted"])
        }
    }
}

extension UpdateTest {
    static var allTests : [(String, (UpdateTest) -> () throws -> Void)] {
        return [
            ("test_replace_index_in_array", test_replace_index_in_array),
        ]
    }
}

