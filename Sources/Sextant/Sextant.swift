import Foundation
import Hitch

public typealias JsonAny = Any?
public typealias JsonArray = [JsonAny]
public typealias JsonDictionary = [String: JsonAny]

/// The exposed API for performing JSON path queries works like this:
/// 1. All practical incoming data types should be handled (ie, you can perform against a String, or Data, or Any?)
/// 2. All practical outgoing data type should be handled (ie, you can receive JsonArray of all results, or a String of the first result)
/// 3. Should support easy codable integration, both array and single results
///
/// Supported incoming data types should be:
/// String, Hitch, Data, JsonAny
///
/// Supported outgoing data types for all results should be:
/// JsonArray, Decodable
///
/// Supported outgoing data types for just the first result should be:
/// String, Hitch, Int, Double, Decodable, JsonAny
///
/// 1. Sextant singleton has all of the code
/// 2. Extensions should be thin wrapper to call Sextant singleton methods
/// 3. Should support sending single path or a union of many path results

// MARK: - Incoming Extensions - Parsing

public extension Hitch {
    @inlinable
    func parsed() -> JsonAny {
        return self.dataNoCopy().parsed()
    }
}

public extension String {
    @inlinable
    func parsed() -> JsonAny {
        return self.data(using: .utf8)?.parsed()
    }
}

public extension Data {
    @inlinable
    func parsed() -> JsonAny {
        return try? JSONSerialization.jsonObject(with: self, options: [.allowFragments])
    }
}

// MARK: - Incoming Extensions - Query

public extension String {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Hitch {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Data {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension JsonAny {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Array {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Dictionary {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public final class Sextant {
    public static let shared = Sextant()
    private init() { }

    public var shouldCachePaths = true

    private var cachedPaths = [Hitch: Path]()
    private var lock = NSLock()

    private func cachedPath(query: Hitch) -> Path? {
        guard shouldCachePaths else { return nil }

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

// MARK: - All Results -> JsonArray

public extension Sextant {
    @inlinable func query(_ root: String,
                          values path: Hitch) -> JsonArray? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)
    }

    @inlinable func query(_ root: Hitch,
                          values path: Hitch) -> JsonArray? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)
    }

    @inlinable func query(_ root: Data,
                          values path: Hitch) -> JsonArray? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)
    }

    @inlinable func query(_ root: String,
                          paths path: Hitch) -> JsonArray? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, paths: path)
    }

    @inlinable func query(_ root: Hitch,
                          paths path: Hitch) -> JsonArray? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, paths: path)
    }

    @inlinable func query(_ root: Data,
                          paths path: Hitch) -> JsonArray? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, paths: path)
    }
}

// MARK: - Tuple Results -> String

extension JsonArray {
    @usableFromInline
    func get(_ index: Int) -> JsonAny {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}

public extension Sextant {
    @inlinable func query<A>(_ root: JsonAny, value path: Hitch) -> (A?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A)
    }

    @inlinable func query<A, B>(_ root: JsonAny, value path: Hitch) -> (A?, B?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B)
    }

    @inlinable func query<A, B, C>(_ root: JsonAny, value path: Hitch) -> (A?, B?, C?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C)
    }

    @inlinable func query<A, B, C, D>(_ root: JsonAny, value path: Hitch) -> (A?, B?, C?, D?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D)
    }

    @inlinable func query<A, B, C, D, E>(_ root: JsonAny, value path: Hitch) -> (A?, B?, C?, D?, E?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D, values.get(4) as? E)
    }

    @inlinable func query<A, B, C, D, E, F>(_ root: JsonAny, value path: Hitch) -> (A?, B?, C?, D?, E?, F?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D, values.get(4) as? E, values.get(5) as? F)
    }
}

// MARK: - First Result -> String

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value path: Hitch) -> String? {
        return query(root, values: path)?.first as? String
    }

    @inlinable func query(_ root: String,
                          value path: Hitch) -> String? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? String
    }

    @inlinable func query(_ root: Hitch,
                          value path: Hitch) -> String? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? String
    }

    @inlinable func query(_ root: Data,
                          value path: Hitch) -> String? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? String
    }
}

// MARK: - First Result -> Hitch

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value path: Hitch) -> Hitch? {
        return query(root, values: path)?.first as? Hitch
    }

    @inlinable func query(_ root: String,
                          value path: Hitch) -> Hitch? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Hitch
    }

    @inlinable func query(_ root: Hitch,
                          value path: Hitch) -> Hitch? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Hitch
    }

    @inlinable func query(_ root: Data,
                          value path: Hitch) -> Hitch? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Hitch
    }
}

// MARK: - First Result -> Int

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value path: Hitch) -> Int? {
        return query(root, values: path)?.first as? Int
    }

    @inlinable func query(_ root: String,
                          value path: Hitch) -> Int? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Int
    }

    @inlinable func query(_ root: Hitch,
                          value path: Hitch) -> Int? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Int
    }

    @inlinable func query(_ root: Data,
                          value path: Hitch) -> Int? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Int
    }
}

// MARK: - First Result -> Double

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value path: Hitch) -> Double? {
        return query(root, values: path)?.first as? Double
    }

    @inlinable func query(_ root: String,
                          value path: Hitch) -> Double? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Double
    }

    @inlinable func query(_ root: Hitch,
                          value path: Hitch) -> Double? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Double
    }

    @inlinable func query(_ root: Data,
                          value path: Hitch) -> Double? {
        guard let jsonData = root.parsed() else { return nil }
        return query(jsonData, values: path)?.first as? Double
    }
}
