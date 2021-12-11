## Sextant

Sextant is a complete, high performance JSONPath implementation written in Swift. It is ported from the [SMJJSONPath](https://github.com/javerous/SMJJSONPath), which in turn is a tight adaptation of the [Jayway JsonPath](https://github.com/json-path/JsonPath) implementation.

## Overview

The original [Stefan Goessner JsonPath implemenentation](https://goessner.net/articles/JsonPath/) was released in 2007, and from it spawned dozens of different implementations. This [JSONPath Comparison](https://cburgmer.github.io/json-path-comparison/) chart shows the wide array of available implemenations, and at the time of this writing a Swift implementation is not present (note that there exists the [SwiftPath](https://github.com/g-mark/SwiftPath) project, but it is not included in said chart [due to critical errors when running on Linux](https://github.com/g-mark/SwiftPath/issues/15).

## Goals

- [x] Simple API
- [x] Full JSONPath implementation
- [x] High performance
- [x] Linux support

## Usage

Each call to Sextant's query() method will return a results array on success and nil on error. Extensions are provided for String, [Any?], and [String:Any?].

```swift
let json = #"["Hello","World"]"#
if let arrayOfResults = json.query(values: "$[0]") {
	// arrayOfResults is ["Hello"]
}
```

You can also avoid the extensions and call query on the Sextant singleton directly.

```swift
let json = #"["Hello","World"]"#
guard let jsonData = json.data(using: .utf8) else { return }
guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
    
if let arrayOfResults = Sextant.shared.query(jsonObject, values: "$[0]") {
	// arrayOfResults is ["Hello"]
}
```

Your data structures do notbe parsed from a JSON string, any existing JSON-like structure can be queried.

```swift
let data = [
    "Hello",
    "World"
]
if let arrayOfResults = Sextant.shared.query(data, values: "$[0]") {
    // arrayOfResults is ["Hello"]
}
```

## Installation

Sextant is fully compatible with the Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/KittyMac/Sextant.git", .branch("main"))
],
```

## License

Sextant is free software distributed under the terms of the MIT license, reproduced below. Sextant may be used for any purpose, including commercial purposes, at absolutely no cost. No paperwork, no royalties, no GNU-like "copyleft" restrictions. Just download and enjoy.

Copyright (c) 2021 [Chimera Software, LLC](http://www.chimerasw.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.