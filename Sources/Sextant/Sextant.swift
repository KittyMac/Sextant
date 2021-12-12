import Foundation
import Hitch

public typealias JsonAny = Any?
public typealias JsonArray = [JsonAny]
public typealias JsonDictionary = [String: JsonAny]

func anyEquals(_ a: JsonAny, _ b: JsonAny?) -> Bool {
    if a == nil && b == nil { return true }
    if let a = a as? CustomStringConvertible,
       let b = b as? CustomStringConvertible {
        if a.description == b.description {
            return true
        }
    }
    return false
}

func error(_ error: String) {
    //#if DEBUG
    //print("Error: " + error)
    //#endif
}

extension Hitch {
    class func combine(_ parts: Hitch...) -> Hitch {
        guard parts.count > 0 else { return Hitch() }

        var total = 0
        parts.forEach { total += $0.count }

        let buffer = Hitch(capacity: total)
        parts.forEach { buffer.append($0) }
        return buffer
    }

    @discardableResult
    @inlinable
    class func make(path: Hitch, index: Int) -> Hitch {
        let clone = Hitch(hitch: path)
        clone.reserveCapacity(clone.count + 32)

        clone.append(UInt8.openBrace)
        clone.append(number: index)
        clone.append(UInt8.closeBrace)

        return clone
    }

    @discardableResult
    @inlinable
    class func make(path: Hitch, property: Hitch) -> Hitch {
        let clone = Hitch(hitch: path)
        clone.reserveCapacity(clone.count + property.count + 2)
        clone.append(UInt8.openBrace)
        clone.append(property)
        clone.append(UInt8.closeBrace)
        return clone
    }

    @discardableResult
    @inlinable
    class func make(path: Hitch, property: Hitch, wrap: UInt8) -> Hitch {
        let clone = Hitch(hitch: path)
        clone.reserveCapacity(clone.count + property.count + 4)
        clone.append(UInt8.openBrace)
        clone.append(wrap)
        clone.append(property)
        clone.append(wrap)
        clone.append(UInt8.closeBrace)
        return clone
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, index: Int) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(number: index)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: Hitch) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(property)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: Hitch, wrap: UInt8) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(wrap)
        hitch.append(property)
        hitch.append(wrap)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: String, wrap: UInt8) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(wrap)
        hitch.append(property)
        hitch.append(wrap)
        hitch.append(UInt8.closeBrace)
    }

    // Hitch.make(path: currentPath, property: properties.joined(delimiter: .comma, wrap: .singleQuote))
}

extension Array where Element == Hitch {
    func joined(delimiter: UInt8, wrap: UInt8) -> Hitch {
        guard count > 0 else { return Hitch() }

        var total = 0
        forEach { total += $0.count + 2 }

        let buffer = Hitch(capacity: total)

        forEach { part in
            if buffer.count > 0 {
                buffer.append(delimiter)
            }
            buffer.append(wrap)
            buffer.append(part)
            buffer.append(wrap)
        }

        return buffer
    }
}

enum ArrayPathCheck: Equatable {
    case handle
    case skip
    case error(String)

    static func == (lhs: ArrayPathCheck, rhs: ArrayPathCheck) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.handle, .handle):
            return true
        case (.skip, .skip):
            return true

        default:
            return false
        }
    }
}

enum EvaluationStatus: Equatable {
    case done
    case aborted
    case error(_ error: String)

    static func == (lhs: EvaluationStatus, rhs: EvaluationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.done, .done):
            return true
        case (.aborted, .aborted):
            return true

        default:
            return false
        }
    }
}

public extension JsonArray {
    @inlinable
    subscript(dict idx: Int) -> JsonDictionary? {
        return self[idx] as? JsonDictionary
    }
    @inlinable
    subscript(date idx: Int) -> Date? {
        if let stringValue = self[idx] as? String {
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
            let matches = detector?.matches(in: stringValue, options: [], range: NSRange(location: 0, length: stringValue.utf16.count))
            return matches?.first?.date
        }
        return self[idx] as? Date
    }
    @inlinable
    subscript(bool idx: Int) -> Bool? {
        return self[idx] as? Bool
    }
    @inlinable
    subscript(string idx: Int) -> String? {
        return self[idx] as? String
    }
    @inlinable
    subscript(int idx: Int) -> Int? {
        if let value = self[idx] as? Int {
            return value
        }
        if let value = self[idx] as? NSString {
            return Int(value.intValue)
        }
        if let value = self[idx] as? String {
            return Int(value)
        }
        return nil
    }
    @inlinable
    subscript(array idx: Int) -> [JsonDictionary]? {
        return self[idx] as? [JsonDictionary]
    }
}

public extension JsonDictionary {
    @inlinable
    subscript(dict key: String) -> JsonDictionary? {
        return self[key] as? JsonDictionary
    }
    @inlinable
    subscript(date key: String) -> Date? {
        if let stringValue = self[key] as? String {
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
            let matches = detector?.matches(in: stringValue, options: [], range: NSRange(location: 0, length: stringValue.utf16.count))
            return matches?.first?.date
        }
        return self[key] as? Date
    }
    @inlinable
    subscript(bool key: String) -> Bool? {
        return self[key] as? Bool
    }
    @inlinable
    subscript(string key: String) -> String? {
        return self[key] as? String
    }
    @inlinable
    subscript(int key: String) -> Int? {
        if let value = self[key] as? Int {
            return value
        }
        if let value = self[key] as? NSString {
            return Int(value.intValue)
        }
        if let value = self[key] as? String {
            return Int(value)
        }
        return nil
    }
    @inlinable
    subscript(array key: String) -> [JsonDictionary]? {
        return self[key] as? [JsonDictionary]
    }
}

public extension JsonArray {
    func spread() -> () {
        return ()
    }
    func spread<A>() -> (A?) {
        return (self[0] as? A)
    }
    func spread<A,B>() -> (A?,B?) {
        return (self[0] as? A, self[1] as? B)
    }
    func spread<A,B,C>() -> (A?,B?,C?) {
        return (self[0] as? A, self[1] as? B, self[2] as? C)
    }
    func spread<A,B,C,D>() -> (A?,B?,C?,D?) {
        return (self[0] as? A, self[1] as? B, self[2] as? C, self[3] as? D)
    }
    func spread<A,B,C,D,E>() -> (A?,B?,C?,D?,E?) {
        return (self[0] as? A, self[1] as? B, self[2] as? C, self[3] as? D, self[4] as? E)
    }
    func spread<A,B,C,D,E,F>() -> (A?,B?,C?,D?,E?,F?) {
        return (self[0] as? A, self[1] as? B, self[2] as? C, self[3] as? D, self[4] as? E, self[5] as? F)
    }
    func spread<A,B,C,D,E,F,G>() -> (A?,B?,C?,D?,E?,F?,G?) {
        return (self[0] as? A, self[1] as? B, self[2] as? C, self[3] as? D, self[4] as? E, self[5] as? F, self[6] as? G)
    }
}

public extension Data {
    func query(values path: Hitch) -> JsonArray? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []) else { return [] }
        return Sextant.shared.query(jsonObject, values: path)
    }
    func query(paths path: Hitch) -> JsonArray? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []) else { return [] }
        return Sextant.shared.query(jsonObject, paths: path)
    }

    func query(values path: String) -> JsonArray? {
        self.query(values: Hitch(stringLiteral: path))
    }
    func query(paths path: String) -> JsonArray? {
        self.query(paths: Hitch(stringLiteral: path))
    }
}

public extension String {
    func query(values path: Hitch) -> JsonArray? {
        guard let jsonData = self.data(using: .utf8) else { return [] }
        return jsonData.query(values: path)
    }
    func query(paths path: Hitch) -> JsonArray? {
        guard let jsonData = self.data(using: .utf8) else { return [] }
        return jsonData.query(paths: path)
    }

    func query(values path: String) -> JsonArray? {
        self.query(values: Hitch(stringLiteral: path))
    }
    func query(paths path: String) -> JsonArray? {
        self.query(paths: Hitch(stringLiteral: path))
    }
}

public extension JsonAny {
    func query(values path: Hitch) -> JsonArray? {
        return Sextant.shared.query(self, values: path)
    }
    func query(paths path: Hitch) -> JsonArray? {
        return Sextant.shared.query(self, paths: path)
    }
}

public extension JsonArray {
    func query(values path: Hitch) -> JsonArray? {
        return Sextant.shared.query(self, values: path)
    }
    func query(paths path: Hitch) -> JsonArray? {
        return Sextant.shared.query(self, paths: path)
    }
}

public extension JsonDictionary {
    func query(values path: Hitch) -> JsonArray? {
        return Sextant.shared.query(self, values: path)
    }
    func query(paths path: Hitch) -> JsonArray? {
        return Sextant.shared.query(self, paths: path)
    }
}

public final class Sextant {
    public static let shared = Sextant()
    private init() { }

    private var cachedPaths = [Hitch: Path]()
    private var lock = NSLock()

    private func cachedPath(query: Hitch) -> Path? {
        lock.lock(); defer { lock.unlock() }

        if let path = cachedPaths[query] {
            return path
        }

        guard let pathCompiler = PathCompiler(query: query) else { return nil }
        guard let path = pathCompiler.compile() else { return nil }

        cachedPaths[query] = path
        return path
    }

    public func query(_ root: JsonAny,
                      values path: Hitch) -> JsonArray? {
        guard let path = cachedPath(query: path) else { return nil }
        if let result = path.evaluate(jsonObject: root,
                                      rootJsonObject: root) {
            return result.resultsValues()
        }
        return nil
    }

    public func query(_ root: JsonAny,
                      paths path: Hitch) -> JsonArray? {
        guard let path = cachedPath(query: path) else { return nil }
        if let result = path.evaluate(jsonObject: root,
                                      rootJsonObject: root) {
            return result.resultsPaths()
        }
        return nil
    }

}
