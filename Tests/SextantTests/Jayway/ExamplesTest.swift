import XCTest
import Hitch
import Spanker
import class Foundation.Bundle

import Sextant

class ExamplesTest: TestsBase {
    
    /// Each call to Sextant's query(values: ) will return an array on success and nil on failure
    func testSimple0() {
        let json: HalfHitch = #"["Hello","World"]"#
        guard let results = json.query(values: "$[0]") else { return XCTFail() }
        XCTAssertEqualAny(results[0], "Hello")
    }
    
    /// You can avoid the provided extensions and call query on the Sextant singleton directly
    func testSimple1() {
        let json = #"["Hello","World"]"#
        guard let jsonData = json.data(using: .utf8) else { return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
        guard let results = Sextant.shared.query(jsonObject, values: "$[0]") else { return XCTFail() }
        XCTAssertEqualAny(results[0], "Hello")
    }
    
    /// Works with any existing JSON-like structure
    func testSimple2() {
        let data = [ "Hello", "World" ]
        guard let results = data.query(values: "$[0]") else { return XCTFail() }
        XCTAssertEqualAny(results[0], "Hello")
    }
    
    /// Automatically covert to simple tuples
    func testSimple3() {
        let json: HalfHitch = #"{"name":"Rocco","age":42}"#
        
        guard let person: (name: String, age: Int) = json.query("$.['name','age']") else { return XCTFail() }
        XCTAssertEqual(person.name, "Rocco")
        XCTAssertEqual(person.age, 42)
        
        guard let person2: (name: String, age: Int?) = json.query("$.['name','age2']") else { return XCTFail() }
        XCTAssertEqual(person2.name, "Rocco")
        XCTAssertEqual(person2.age, nil)
        
        if let _: (name: String, age: Int) = json.query("$.['name','age2']") {
            return XCTFail()
        }
    }
    
    /// Supports Decodable structs
    func testSimple4() {
        let json: HalfHitch = #"{"data":{"people":[{"name":"Rocco","age":42},{"name":"John","age":12},{"name":"Elizabeth","age":35},{"name":"Victoria","age":85}]}}"#
        
        class Person: Decodable {
            let name: String
            let age: Int
        }
        
        guard let persons: [Person] = json.query("$..[?(@.name)]") else { return XCTFail() }
        XCTAssertEqual(persons[0].name, "Rocco")
        XCTAssertEqual(persons[0].age, 42)
        XCTAssertEqual(persons[2].name, "Elizabeth")
        XCTAssertEqual(persons[2].age, 35)
    }
    
    /// Easily combine results from multiple queries
    func testSimple5() {
        let json1 = #"{"error": "invalid_request", "error_description": "Mismatching redirect URI."}"#
        let json2 = #"{"errors":[{"title":"Error!","detail":"Error format 2"}]}"#
                
        let queries: [String] = [
            "$.['error','error_description']",
            "$.errors[0].['title','detail']"
        ]
        
        XCTAssertEqualAny(json1.query(values: queries), ["Mismatching redirect URI.", "invalid_request"])
        XCTAssertEqualAny(json2.query(values: queries), ["Error format 2", "Error!"])
    }
    
    func testSimple6() {
        let json1 = #"{"access_token":"aex-0u-7Yq09sBls123456789","expires_in":2678400,"token_type":"Bearer","scope":"identity","refresh_token":"CayptzsmZ_MejrKgNtAF8ka36123456789","version":"0.0.1"}"#
        
        if let _: (title: String, detail: String) = json1.query([
            "$.['error','error_description']",
            "$.errors[0].['title','detail']"
        ]) {
            XCTFail()
        }
    }
    
    func testSimple7() {
        // note: email is missing from this one
        let json: Hitch = #"{"data":{"attributes":{"about":null,"created":"2021-12-19T18:06:51.000+00:00","first_name":"John","full_name":"John Doe","image_url":"https://www.example.com/image.png","last_name":"Doe","thumb_url":"https://www.example.com/image.png","url":"https://www.example.com/user?u=234576235","vanity":null},"id":"234576235","type":"user"},"links":{"self":"https://www.example.com/api/oauth2/v2/user/234576235"}}"#
        
        if let x: (name: String?,
                   firstName: String?,
                   lastName: String?,
                   email: String,
                   imageUrl: String?) = json.query("$.data.attributes['full_name','first_name','last_name','email','thumb_url']") {
            print(x)
            XCTFail()
        }
        
        if let _: (name: String,
                   firstName: String,
                   lastName: String,
                   email: String?,
                   imageUrl: String) = json.query("$.data.attributes['full_name','first_name','last_name','email','thumb_url']") {
            
        } else {
            XCTFail()
        }
    }
    
    func testSimple8() {
        let data = #"{"data":{"attributes":{"about":null,"created":"2021-12-19T18:06:51.000+00:00","social_connections":{"deviantart":null,"discord":null,"facebook":null,"google":null,"instagram":null,"reddit":null,"spotify":null,"twitch":null,"twitter":null,"vimeo":null,"youtube":null},"vanity":null},"id":"66480799","type":"user"}}"#
        
        data.parsed { json in
            guard let json = json else { XCTFail(); return }
            guard let id: String = json.query("$.data.id") else { XCTFail(); return }
            XCTAssertEqual(id, "66480799")
        }
    }
    
    /// High performance JSON processing by using .parsed() to get
    /// a quick view of the raw json to execute on paths on
    func testSimple9() {
        let data = #"{"DtCutOff":"2018-01-01 00:00:00","ServiceGroups":[{"ServiceName":"Service1","DtUpdate":"2021-11-22 00:00:00","OrderNumber":"123456","Active":"true"},{"ServiceName":"Service2","DtUpdate":"2021-11-20 00:00:00","OrderNumber":"123456","Active":true},{"ServiceName":"Service3","DtUpdate":"2021-11-10 00:00:00","OrderNumber":"123456","Active":false}]}"#
            
        data.parsed { json in
            guard let json = json else { XCTFail(); return }
        
            guard let isActive: Bool = json.query("$.ServiceGroups[*][?(@.ServiceName=='Service1')].Active") else { XCTFail(); return }
            XCTAssertEqual(isActive, true)
            
            guard let date: Date = json.query("$.ServiceGroups[*][?(@.ServiceName=='Service1')].DtUpdate") else { XCTFail(); return }
            XCTAssertEqual(date, "2021-11-22 00:00:00".date())
        }
    }
    
    /// Use replace, map, filter, remove and forEach to perform mofications to your json
    func testSimple10() {
        let json: HalfHitch = #"{"data":{"people":[{"name":"Rocco","age":42,"gender":"m"},{"name":"John","age":12,"gender":"m"},{"name":"Elizabeth","age":35,"gender":"f"},{"name":"Victoria","age":85,"gender":"f"}]}}"#

        let modifiedJson: String? = json.parsed { root in
            guard let root = root else { XCTFail(); return nil }
            
            // Remove all females
            root.query(remove: "$..people[?(@.gender=='f')]")
            
            // Incremet all ages by 1
            root.query(map: "$..age", {
                guard let age = $0.intValue else { return $0 }
                return age + 1
            })
            
            // Lowercase all names
            root.query(map: "$..name", { $0.hitchValue?.lowercase() })
            
            return root.description
        }
        
        XCTAssertEqual(modifiedJson, #"{"data":{"people":[{"name":"rocco","age":43,"gender":"m"},{"name":"john","age":13,"gender":"m"}]}}"#)
    }
    
    /// Use a single map to accomplish the same task as above but with only one pass through the data
    func testSimple11() {
        let json: HalfHitch = #"{"data":{"people":[{"name":"Rocco","age":42,"gender":"m"},{"name":"John","age":12,"gender":"m"},{"name":"Elizabeth","age":35,"gender":"f"},{"name":"Victoria","age":85,"gender":"f"}]}}"#
        
        let modifiedJson: String? = json.query(map: "$..people[*] ", { person in
            // Remove all females, increment age by 1, lowercase all names
            guard person["gender"]?.stringValue == "m" else {
                return nil
            }
            if let age = person["age"]?.intValue {
                person.set(key: "age", value: age + 1)
            }
            if let name = person["name"]?.hitchValue {
                person.set(key: "name", value: name.lowercase())
            }
            return person
        }) { root in
            return root.description
        }

        XCTAssertEqual(modifiedJson, #"{"data":{"people":[{"name":"rocco","age":43,"gender":"m"},{"name":"john","age":13,"gender":"m"}]}}"#)
    }
    
    /// You are not bound to just modify existing elements in your JSON,
    /// you can return any json-like structure in your mapping
    func testSimple12() {
        let oldJson = #"{"someValue": ["elem1", "elem2", "elem3"]}"#
        let newJson: String? = oldJson.query(map: "$.someValue", {_ in
            return ["elem4", "elem5"]
        } ) { root in
            return root.description
        }
        XCTAssertEqual(newJson, #"{"someValue":["elem4","elem5"]}"#)
    }
    
    /// For the performance minded, your maps should do as little work as possible
    /// per replacement. To improve on the previous example, we could create our
    /// replacement element outside of the mapping to reduce unnecessary work.
    func testSimple13() {
        let oldJson = #"{"someValue": ["elem1", "elem2", "elem3"]}"#
        let replacementElement = JsonElement(unknown: ["elem4", "elem5"])
        let newJson: String? = oldJson.query(map: "$.someValue", {_ in
            return replacementElement
        } ) { root in
            return root.description
        }
        XCTAssertEqual(newJson, #"{"someValue":["elem4","elem5"]}"#)
    }
    
    
    /// Example of handling an heterogenous array. The task is to iterate over all
    /// operations and perform a dynamic lookup to the operation function, perform
    /// the task and coallate the results.
    func testSimple14() {
        let json: HalfHitch = #"[{"name":"add","inputs":[3,4]},{"name":"subtract","inputs":[6,3]},{"echo":"Hello, world"},{"name":"increment","input":41},{"echo":"Hello, world"}]"#
        
        let operations: [HalfHitch: (JsonElement) -> (Int?)] = [
            "add": { input in
                guard let values = input[element: "inputs"] else { return nil }
                guard let lhs = values[int: 0] else { return nil }
                guard let rhs = values[int: 1] else { return nil }
                return lhs + rhs
            },
            "subtract": { input in
                guard let values = input[element: "inputs"] else { return nil }
                guard let lhs = values[int: 0] else { return nil }
                guard let rhs = values[int: 1] else { return nil }
                return lhs - rhs
            },
            "increment": { input in
                guard let value = input[int: "input"] else { return nil }
                return value + 1
            }
        ]
        
        var results = [Int]()
        
        json.query(forEach: #"$[?(@.name)]"#) { operation in
            if let opName = operation[halfHitch: "name"],
               let opFunc = operations[opName] {
                results.append(opFunc(operation) ?? 0)
            }
        }
                
        XCTAssertEqual(results, [7,3,42])
    }
    
    /// JsonElements can be the return value if queried against an existing JsonElement
    func testSimple15() {
        let json: HalfHitch = #"[{"name":"Rocco","age":42},{"name":"John","age":36}]"#
        
        
        json.parsed { root in
            guard let root = root else { XCTFail(); return }
                        
            guard let persons = root.query(elements: "$[*]") else { XCTFail(); return }
                        
            XCTAssertEqual(persons[0][hitch: "name"], "Rocco")
            XCTAssertEqual(persons[0][int: "age"], 42)
            
            XCTAssertEqual(persons[1][hitch: "name"], "John")
            XCTAssertEqual(persons[1][int: "age"], 36)
            
            guard let person: JsonElement = root.query("$[1]") else { XCTFail(); return }
            
            XCTAssertEqual(person[hitch: "name"], "John")
            XCTAssertEqual(person[int: "age"], 36)
        }
    }
    
    /// JsonElements can be the return value if queried against an existing JsonElement
    func testSimple16() {
        let json = #"[{"title":"Post 1","timestamp":1},{"title":"Post 2","timestamp":2}]"#
        
        
        
        // ===== Method 0: compatible with JSONSerialization =====
        // First method is like using JSONSerialization; returns a "JSONArray" which
        // is just a typealias for [Any?]. Least efficient method, annoying to use.
        let result0 = json.query(values: "$[*]")!
        
        // prints: Optional([Optional(["title": Optional("Post 1"), "timestamp": Optional(1)]), Optional(["name": Optional("Post 2"), "timestamp": Optional(2)])])
        print(result0)
        
        if let result0JsonData = try? JSONSerialization.data(withJSONObject: result0, options: [.sortedKeys]),
           // prints: [{"timestamp":1,"title":"Post 1"},{"title":"Post 2","timestamp":2}]
           let result0JsonString = String(data: result0JsonData, encoding: .utf8) {
            print(result0JsonString)
        }

        
        // ===== Method 1: coerce Codable structs =====
        // Middle efficiency, more convenient coding.
        struct LikedPost: Codable {
            let title: String
            let timestamp: Int
        }
        
        let result1: [LikedPost] = json.query("$[*]")!
        // prints: "Post 1"
        print(result1[0].title)
        
        
        // ===== Method 2a: JsonElement =====
        // JsonElements are the internal structures used by Sextant; they have references
        // which point to the original content so they can be used without any unnecessary
        // copying of data. Since they reference the original data, you need to ensure that
        // they get converted to a more real format for use elsewhere.
        
        var result2a: [LikedPost] = []
        json.query(forEach: "$[*]") { item in
            if let title = item[string: "title"],
               let timestamp = item[int: "timestamp"] {
                result2a.append(LikedPost(title: title, timestamp: timestamp))
            }
        }
        // prints: "Post 1"
        print(result2a[0].title)
        
        // ===== Method 2b: JsonElement =====
        // When working with JsonElements, its often advisable to use the parsed() method. This ensures
        // that the data the JsonElements reference is alive while using them. It also allows you to
        // perform multiple queries against the same json very efficiently, as you have the root
        // JsonElement directly for all queries.
        var result2b: [LikedPost] = []
        json.parsed { root in
            guard let root = root else { return }
            
            // Contrived: pulling the two values out using different queries just to prove the
            // point. The json is already parsed so queries inside here are very fast
            if let titles: [String] = root.query("$..title"),
               let timestamps: [Int] = root.query("$..timestamp"),
               titles.count == timestamps.count {
                for idx in 0..<titles.count {
                    result2b.append(LikedPost(title: titles[idx], timestamp: timestamps[idx]))
                }
            }
        }
        // prints: "Post 1"
        print(result2b[0].title)
    }
    
    /// Check a jsonpath for validity
    func testSimple17() {
        let json = #"[{"title":"Post 1","timestamp":1},{"title":"Post 2","timestamp":2}]"#

        XCTAssertEqual(json.query(validate: "$"), nil)
        XCTAssertEqual(json.query(validate: ""), "Path must start with $ or @")
        XCTAssertEqual(json.query(validate: "$."), "Path must not end with a \'.\' or \'..\'")
        XCTAssertEqual(json.query(validate: "$.."), "Path must not end with a \'.\' or \'..\'")
        XCTAssertEqual(json.query(validate: "$.store.book[["), "Could not parse token starting at position 12.")
    }
}

extension ExamplesTest {
    static var allTests : [(String, (ExamplesTest) -> () throws -> Void)] {
        return [
            ("testSimple0", testSimple0),
            ("testSimple1", testSimple1),
            ("testSimple2", testSimple2),
            ("testSimple3", testSimple3),
            ("testSimple4", testSimple4),
            ("testSimple5", testSimple5),
            ("testSimple6", testSimple6),
            ("testSimple7", testSimple7),
            ("testSimple8", testSimple8),
            ("testSimple9", testSimple9),
            ("testSimple10", testSimple10),
            ("testSimple11", testSimple11),
            ("testSimple12", testSimple12),
            ("testSimple13", testSimple13),
            ("testSimple14", testSimple14),
        ]
    }
}

