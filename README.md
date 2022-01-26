![](meta/icon.png)

## Sextant

Sextant is a complete, high performance JSONPath implementation written in Swift. It was originally ported from [SMJJSONPath](https://github.com/javerous/SMJJSONPath), which in turn is a tight adaptation of the [Jayway JsonPath](https://github.com/json-path/JsonPath) implementation. Sextant has since been updated to bring it into compliance with other JSON path implementations ([see issue](https://github.com/javerous/SMJJSONPath/issues/6)), so this specific implementation now varies from the SMJJSONPath/Jayway implementation.

## Getting Started

- [Experience Sextant in our online playground!](https://www.swift-linux.com)
- [New to JSONPath?  Read this.](#what-is-jsonpath)
- [Using Sextant in your Swift project.](#usage)

## Goals

- [x] Simple API
- [x] Full JSONPath implementation
- [x] Modification of paths ( use map/filter/remove/forEach )
- [x] High performance
- [x] Linux support


## Usage


```swift
import Sextant

/// Each call to Sextant's query(values: ) will return an array on success and nil on failure
func testSimple0() {
    let json = #"["Hello","World"]"#
    guard let results = json.query(values: "$[0]") else { return XCTFail() }
    XCTAssertEqualAny(results[0], "Hello")
}
```

```swift
/// Works with any existing JSON-like structure
func testSimple2() {
    let data = [ "Hello", "World" ]
    guard let results = data.query(values: "$[0]") else { return XCTFail() }
    XCTAssertEqualAny(results[0], "Hello")
}
```

```swift
/// Automatically covert to simple tuples
func testSimple3() {
    let json = #"{"name":"Rocco","age":42}"#
    
    guard let person: (name: String?, age: Int?) = json.query("$.['name','age']") else { return XCTFail() }
    XCTAssertEqual(person.name, "Rocco")
    XCTAssertEqual(person.age, 42)
}
```

```swift
/// Supports Decodable structs
func testSimple4() {
    let json = #"{"data":{"people":[{"name":"Rocco","age":42},{"name":"John","age":12},{"name":"Elizabeth","age":35},{"name":"Victoria","age":85}]}}"#
    
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
```

```swift
/// Easily combine results from multiple queries
func testSimple5() {
    let json1 = #"{"error":"Error format 1"}"#
    let json2 = #"{"errors":[{"title:":"Error!","detail":"Error format 2"}]}"#
            
    let queries: [String] = [
        "$.error",
        "$.errors[0].detail",
    ]
    
    XCTAssertEqualAny(json1.query(string: queries), "Error format 1")
    XCTAssertEqualAny(json2.query(string: queries), "Error format 2")
}
```

```swift
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
```

```swift
/// Use replace, map, filter, remove and forEach to perform mofications to your json
func testSimple10() {
    let json = #"{"data":{"people":[{"name":"Rocco","age":42,"gender":"m"},{"name":"John","age":12,"gender":"m"},{"name":"Elizabeth","age":35,"gender":"f"},{"name":"Victoria","age":85,"gender":"f"}]}}"#

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
```

```swift
/// Use a single map to accomplish the same task as above but with only one pass through the data
func testSimple11() {
    let json = #"{"data":{"people":[{"name":"Rocco","age":42,"gender":"m"},{"name":"John","age":12,"gender":"m"},{"name":"Elizabeth","age":35,"gender":"f"},{"name":"Victoria","age":85,"gender":"f"}]}}"#
    
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
```

```swift
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
```

```swift
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
```

## Performance

Sextant utilizes [Hitch](https://github.com/KittyMac/Hitch) (high performance strings) and [Spanker](https://github.com/KittyMac/Spanker) (high performance, low overhead JSON deserialization) to provide a best-in-class JSONPath implementation for Swift. Hitch allows for fast, utf8 shared memory strings. Spanker generates a low cost view of the JSON blob which Sextant then queries the JSONPath against. Nothing is deserialized and no memory is copied from the source JSON blob until they are returned as results from the query. Sextant really shines in scenarios where you have a large amount of JSON and/or a large number of queries to run against it.

![](meta/chart.png)

## Installation

Sextant is fully compatible with the Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/KittyMac/Sextant.git", .upToNextMinor(from: "0.4.0"))
],
```

## What is JSONPath

The original [Stefan Goessner JsonPath implemenentation](https://goessner.net/articles/JsonPath/) was released in 2007, and from it spawned dozens of different implementations. This [JSONPath Comparison](https://cburgmer.github.io/json-path-comparison/) chart shows the wide array of available implemenations, and at the time of this writing a Swift implementation is not present (note that there exists the [SwiftPath](https://github.com/g-mark/SwiftPath) project, but it is not included in said chart [due to critical errors when running on Linux](https://github.com/g-mark/SwiftPath/issues/15).

The rest of this section is largely adapted from the [Jayway JsonPath Getting Started](https://github.com/json-path/JsonPath#getting-started) section.

Operators
---------

| Operator                  | Description                                                        |
| :------------------------ | :----------------------------------------------------------------- |
| `$`                       | The root element to query. This starts all path expressions.       |
| `@`                       | The current node being processed by a filter predicate.            |
| `*`                       | Wildcard. Available anywhere a name or numeric are required.       |
| `..`                      | Deep scan. Available anywhere a name is required.                  |
| `.<name>`                 | Dot-notated child                                                  |
| `['<name>' (, '<name>')]` | Bracket-notated child or children                                  |
| `[<number> (, <number>)]` | Array index or indexes                                             |
| `[start:end]`             | Array slice operator                                               |
| `[?(<expression>)]`       | Filter expression. Expression must evaluate to a boolean value.    |


Functions
---------

Functions can be invoked at the tail end of a path - the input to a function is the output of the path expression.
The function output is dictated by the function itself.

| Function                  | Description                                                         | Output type |
| :------------------------ | :------------------------------------------------------------------ |:----------- |
| min()                     | Provides the min value of an array of numbers                       | Double      |
| max()                     | Provides the max value of an array of numbers                       | Double      |
| avg()                     | Provides the average value of an array of numbers                   | Double      | 
| stddev()                  | Provides the standard deviation value of an array of numbers        | Double      | 
| length()                  | Provides the length of an array                                     | Integer     |
| sum()                     | Provides the sum value of an array of numbers                       | Double      |
| keys()                    | Provides the property keys (An alternative for terminal tilde `~`)  | `Set<E>`    |
| concat(X)                 | Provides a concatinated version of the path output with a new item  | like input  |
| append(X)                 | add an item to the json path output array                           | like input  |

Filter Operators
-----------------

Filters are logical expressions used to filter arrays. A typical filter would be `[?(@.age > 18)]` where `@` represents the current item being processed. More complex filters can be created with logical operators `&&` and `||`. String literals must be enclosed by single or double quotes (`[?(@.color == 'blue')]` or `[?(@.color == "blue")]`).   

| Operator                 | Description                                                           |
| :----------------------- | :-------------------------------------------------------------------- |
| ==                       | left is equal to right (note that 1 is not equal to '1')              |
| !=                       | left is not equal to right                                            |
| <                        | left is less than right                                               |
| <=                       | left is less or equal to right                                        |
| >                        | left is greater than right                                            |
| >=                       | left is greater than or equal to right                                |
| =~                       | left matches regular expression  [?(@.name =~ /foo.*?/i)]             |
| in                       | left exists in right [?(@.size in ['S', 'M'])]                        |
| nin                      | left does not exists in right                                         |
| subsetof                 | left is a subset of right [?(@.sizes subsetof ['S', 'M', 'L'])]       |
| anyof                    | left has an intersection with right [?(@.sizes anyof ['M', 'L'])]     |
| noneof                   | left has no intersection with right [?(@.sizes noneof ['M', 'L'])]    |
| size                     | size of left (array or string) should match right                     |
| empty                    | left (array or string) should be empty                                |


Path Examples
-------------

Given the json

```javascript
{
  "store": {
    "book": [
      {
        "category": "reference",
        "author": "Nigel Rees",
        "title": "Sayings of the Century",
        "display-price": 8.95,
        "bargain": true
      },
      {
        "category": "fiction",
        "author": "Evelyn Waugh",
        "title": "Sword of Honour",
        "display-price": 12.99,
        "bargain": false
      },
      {
        "category": "fiction",
        "author": "Herman Melville",
        "title": "Moby Dick",
        "isbn": "0-553-21311-3",
        "display-price": 8.99,
        "bargain": true
      },
      {
        "category": "fiction",
        "author": "J. R. R. Tolkien",
        "title": "The Lord of the Rings",
        "isbn": "0-395-19395-8",
        "display-price": 22.99,
        "bargain": false
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
```

| JsonPath (click link to try)| Result |
| :------- | :----- |
| <a href="https://www.swift-linux.com/?example=0&path=0" target="_blank">$.store.book[*].author</a>| The authors of all books     |
| <a href="https://www.swift-linux.com/?example=0&path=1" target="_blank">$..['author','title']</a>                   | All authors and titles                         |
| <a href="https://www.swift-linux.com/?example=0&path=3" target="_blank">$.store.*</a>                  | All things, both books and bicycles  |
| <a href="https://www.swift-linux.com/?example=0&path=4" target="_blank">$.store..display-price</a>             | The price of everything         |
| <a href="https://www.swift-linux.com/?example=0&path=5" target="_blank">$..book[2]</a>                 | The third book                      |
| <a href="https://www.swift-linux.com/?example=0&path=6" target="_blank">$..book[-2]</a>                 | The second to last book            |
| <a href="https://www.swift-linux.com/?example=0&path=7" target="_blank">$..book[0,1]</a>               | The first two books               |
| <a href="https://www.swift-linux.com/?example=0&path=8" target="_blank">$..book[:2]</a>                | All books from index 0 (inclusive) until index 2 (exclusive) |
| <a href="https://www.swift-linux.com/?example=0&path=9" target="_blank">$..book[1:2]</a>                | All books from index 1 (inclusive) until index 2 (exclusive) |
| <a href="https://www.swift-linux.com/?example=0&path=10" target="_blank">$..book[-2:]</a>                | Last two books                   |
| <a href="https://www.swift-linux.com/?example=0&path=11" target="_blank">$..book[2:]</a>                | Book number two from tail          |
| <a href="https://www.swift-linux.com/?example=0&path=12" target="_blank">$..book[?(@.isbn)]</a>          | All books with an ISBN number         |
| <a href="https://www.swift-linux.com/?example=0&path=13" target="_blank">$.store.book[?(@.display-price < 10)]</a> | All books in store cheaper than 10  |
| <a href="https://www.swift-linux.com/?example=0&path=14" target="_blank">$..book[?(@.bargain == true)]</a> | All bargain books in store  |
| <a href="https://www.swift-linux.com/?example=0&path=15" target="_blank">$..book[?(@.author =~ /.*REES/i)]</a> | All books matching regex (ignore case)  |
| <a href="https://www.swift-linux.com/?example=0&path=16" target="_blank">$..*</a>                        | Give me every thing   
| <a href="https://www.swift-linux.com/?example=0&path=17" target="_blank">$..book.length()</a>                 | The number of books                      |


## License

Sextant is free software distributed under the terms of the MIT license, reproduced below. Sextant may be used for any purpose, including commercial purposes, at absolutely no cost. No paperwork, no royalties, no GNU-like "copyleft" restrictions. Just download and enjoy.

Copyright (c) 2021 [Chimera Software, LLC](http://www.chimerasw.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
