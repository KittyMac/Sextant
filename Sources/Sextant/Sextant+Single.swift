import Foundation
import Hitch

// MARK: - Incoming Extensions - Query

public extension String {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A>(_ path: Hitch) -> (A?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B>(_ path: Hitch) -> (A?, B?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: Hitch) -> (A?, B?, C?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: Hitch) -> (A?, B?, C?, D?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: Hitch) -> (A?, B?, C?, D?, E?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: Hitch) -> (A?, B?, C?, D?, E?, F?)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: Hitch) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(string path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(hitch path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(int path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(double path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Hitch {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A>(_ path: Hitch) -> (A?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B>(_ path: Hitch) -> (A?, B?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: Hitch) -> (A?, B?, C?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: Hitch) -> (A?, B?, C?, D?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: Hitch) -> (A?, B?, C?, D?, E?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: Hitch) -> (A?, B?, C?, D?, E?, F?)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: Hitch) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(string path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(hitch path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(int path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(double path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Data {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A>(_ path: Hitch) -> (A?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B>(_ path: Hitch) -> (A?, B?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: Hitch) -> (A?, B?, C?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: Hitch) -> (A?, B?, C?, D?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: Hitch) -> (A?, B?, C?, D?, E?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: Hitch) -> (A?, B?, C?, D?, E?, F?)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: Hitch) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(string path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(hitch path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(int path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(double path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension JsonAny {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A>(_ path: Hitch) -> (A?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B>(_ path: Hitch) -> (A?, B?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: Hitch) -> (A?, B?, C?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: Hitch) -> (A?, B?, C?, D?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: Hitch) -> (A?, B?, C?, D?, E?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: Hitch) -> (A?, B?, C?, D?, E?, F?)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: Hitch) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(string path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(hitch path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(int path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(double path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Array {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A>(_ path: Hitch) -> (A?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B>(_ path: Hitch) -> (A?, B?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: Hitch) -> (A?, B?, C?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: Hitch) -> (A?, B?, C?, D?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: Hitch) -> (A?, B?, C?, D?, E?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: Hitch) -> (A?, B?, C?, D?, E?, F?)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: Hitch) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(string path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(hitch path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(int path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(double path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Dictionary {
    @inlinable func query(paths: Hitch) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: Hitch) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: Hitch) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: Hitch) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: Hitch) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: Hitch) -> Double? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A>(_ path: Hitch) -> (A?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B>(_ path: Hitch) -> (A?, B?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: Hitch) -> (A?, B?, C?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: Hitch) -> (A?, B?, C?, D?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: Hitch) -> (A?, B?, C?, D?, E?)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: Hitch) -> (A?, B?, C?, D?, E?, F?)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: Hitch) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: String) -> JsonArray? { return Sextant.shared.query(self, paths: Hitch(stringLiteral: paths)) }
    @inlinable func query(values path: String) -> JsonArray? { return Sextant.shared.query(self, values: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(string path: String) -> String? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(hitch path: String) -> Hitch? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(int path: String) -> Int? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(_ path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
    @inlinable func query(double path: String) -> Double? { return Sextant.shared.query(self, value: Hitch(stringLiteral: path)) }
}

public extension Sextant {

    func query(_ root: JsonAny,
               values path: Hitch) -> JsonArray? {
        guard let path = cachedPath(query: path) else { return nil }
        if let result = path.evaluate(jsonObject: root,
                                      rootJsonObject: root) {
            return result.resultsValues()
        }
        return nil
    }

    func query(_ root: JsonAny,
               paths path: Hitch) -> JsonArray? {
        guard let path = cachedPath(query: path) else { return nil }
        if let result = path.evaluate(jsonObject: root,
                                      rootJsonObject: root) {
            return result.resultsPaths()
        }
        return nil
    }
}

// MARK: - All Results -> Decodable

public extension Sextant {
    @inlinable func query<T: Decodable>(_ root: String,
                                        values path: Hitch) -> T? {
        // Not exactly performant, but this will work in all cases...
        guard let jsonData = root.parsed() else { return nil }
        guard let results = query(jsonData, values: path) else { return nil }
        guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
        return try? JSONDecoder().decode(T.self, from: resultsJson)
    }

    @inlinable func query<T: Decodable>(_ root: Hitch,
                                        values path: Hitch) -> T? {
        // Not exactly performant, but this will work in all cases...
        guard let jsonData = root.parsed() else { return nil }
        guard let results = query(jsonData, values: path) else { return nil }
        guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
        return try? JSONDecoder().decode(T.self, from: resultsJson)
    }

    @inlinable func query<T: Decodable>(_ root: Data,
                                        values path: Hitch) -> T? {
        // Not exactly performant, but this will work in all cases...
        guard let jsonData = root.parsed() else { return nil }
        guard let results = query(jsonData, values: path) else { return nil }
        guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
        return try? JSONDecoder().decode(T.self, from: resultsJson)
    }

    @inlinable func query<T: Decodable>(_ root: JsonAny,
                                        values path: Hitch) -> T? {
        // Not exactly performant, but this will work in all cases...
        guard let results = query(root, values: path) else { return nil }
        guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
        return try? JSONDecoder().decode(T.self, from: resultsJson)
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

// MARK: - Results -> Tuple

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

    @inlinable func query<A>(_ root: String, value path: Hitch) -> (A?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A)
    }
    @inlinable func query<A, B>(_ root: String, value path: Hitch) -> (A?, B?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B)
    }
    @inlinable func query<A, B, C>(_ root: String, value path: Hitch) -> (A?, B?, C?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C)
    }
    @inlinable func query<A, B, C, D>(_ root: String, value path: Hitch) -> (A?, B?, C?, D?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D)
    }
    @inlinable func query<A, B, C, D, E>(_ root: String, value path: Hitch) -> (A?, B?, C?, D?, E?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D, values.get(4) as? E)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: String, value path: Hitch) -> (A?, B?, C?, D?, E?, F?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D, values.get(4) as? E, values.get(5) as? F)
    }

    @inlinable func query<A>(_ root: Hitch, value path: Hitch) -> (A?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A)
    }
    @inlinable func query<A, B>(_ root: Hitch, value path: Hitch) -> (A?, B?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B)
    }
    @inlinable func query<A, B, C>(_ root: Hitch, value path: Hitch) -> (A?, B?, C?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C)
    }
    @inlinable func query<A, B, C, D>(_ root: Hitch, value path: Hitch) -> (A?, B?, C?, D?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D)
    }
    @inlinable func query<A, B, C, D, E>(_ root: Hitch, value path: Hitch) -> (A?, B?, C?, D?, E?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D, values.get(4) as? E)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: Hitch, value path: Hitch) -> (A?, B?, C?, D?, E?, F?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D, values.get(4) as? E, values.get(5) as? F)
    }

    @inlinable func query<A>(_ root: Data, value path: Hitch) -> (A?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A)
    }
    @inlinable func query<A, B>(_ root: Data, value path: Hitch) -> (A?, B?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B)
    }
    @inlinable func query<A, B, C>(_ root: Data, value path: Hitch) -> (A?, B?, C?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C)
    }
    @inlinable func query<A, B, C, D>(_ root: Data, value path: Hitch) -> (A?, B?, C?, D?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D)
    }
    @inlinable func query<A, B, C, D, E>(_ root: Data, value path: Hitch) -> (A?, B?, C?, D?, E?)? {
        guard let values: JsonArray = query(root, values: path) else { return nil }
        return (values.get(0) as? A, values.get(1) as? B, values.get(2) as? C, values.get(3) as? D, values.get(4) as? E)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: Data, value path: Hitch) -> (A?, B?, C?, D?, E?, F?)? {
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
