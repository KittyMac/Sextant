import XCTest
import class Foundation.Bundle

import Sextant

func XCTAssertEqualAny(_ first: Any, _ second: Any) {
    if let first = first as? [String],
       let second = second as? [String] {
        XCTAssertEqual(first.sorted().joined(),
                       second.sorted().joined())
        return
    }
    
    guard let firstData = try? JSONSerialization.data(withJSONObject: first, options: [.sortedKeys]) else { XCTAssertTrue(false); return }
    guard let secondData = try? JSONSerialization.data(withJSONObject: second, options: [.sortedKeys]) else { XCTAssertTrue(false); return }
    XCTAssertEqual(String(data: firstData, encoding: .utf8),
                   String(data: secondData, encoding: .utf8))
}


class TestsBase: XCTestCase {
    
    func decode(json jsonString: String) -> JsonAny {
        guard let jsonData = jsonString.data(using: .utf8) else { fatalError("unable to create json data") }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { fatalError("unable to serialize json string") }
        
        return jsonObject
    }
    
    
    
    let jsonDocument = """
    {
        "string-property": "string-value",
        "int-max-property": \(UINT32_MAX),
        "long-max-property": \(UINT64_MAX),
        "boolean-property": true,
        "null-property": null,
        "int-small-property": 1,
        "max-price": 10,
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
                "foo": "baz",
                "escape": "Esc\\b\\f\\n\\r\\t\\n\\t\\u002A",
                "color": "red",
                "display-price": 19.95,
                "foo:bar": "fooBar",
                "dot.notation": "new",
                "dash-notation": "dashes"
            }
        },
        "foo": "bar",
        "@id": "ID"
    }
    """
}
