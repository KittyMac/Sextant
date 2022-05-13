import Foundation
import Hitch
import Spanker

// MARK: - Incoming Extensions - Query

public extension String {
    @inlinable func query(paths: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(bool path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(date path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A, B>(_ path: [Hitch]) -> (A, B)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: [Hitch]) -> (A, B, C)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: [Hitch]) -> (A, B, C, D)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: [Hitch]) -> (A, B, C, D, E)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: [Hitch]) -> (A, B, C, D, E, F)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: [Hitch]) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: [String]) -> JsonArray? { return Sextant.shared.query(self, paths: paths.map { Hitch(string: $0) }) }
    @inlinable func query(values path: [String]) -> JsonArray? { return Sextant.shared.query(self, values: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(string path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(hitch path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(int path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(double path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(bool path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(date path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
}

public extension Hitch {
    @inlinable func query(paths: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(bool path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(date path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A, B>(_ path: [Hitch]) -> (A, B)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: [Hitch]) -> (A, B, C)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: [Hitch]) -> (A, B, C, D)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: [Hitch]) -> (A, B, C, D, E)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: [Hitch]) -> (A, B, C, D, E, F)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: [Hitch]) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: [String]) -> JsonArray? { return Sextant.shared.query(self, paths: paths.map { Hitch(string: $0) }) }
    @inlinable func query(values path: [String]) -> JsonArray? { return Sextant.shared.query(self, values: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(string path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(hitch path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(int path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(double path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(bool path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(date path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
}

public extension Data {
    @inlinable func query(paths: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(bool path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(date path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A, B>(_ path: [Hitch]) -> (A, B)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: [Hitch]) -> (A, B, C)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: [Hitch]) -> (A, B, C, D)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: [Hitch]) -> (A, B, C, D, E)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: [Hitch]) -> (A, B, C, D, E, F)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: [Hitch]) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: [String]) -> JsonArray? { return Sextant.shared.query(self, paths: paths.map { Hitch(string: $0) }) }
    @inlinable func query(values path: [String]) -> JsonArray? { return Sextant.shared.query(self, values: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(string path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(hitch path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(int path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(double path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(bool path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(date path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
}

public extension JsonAny {
    @inlinable func query(paths: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(bool path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(date path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A, B>(_ path: [Hitch]) -> (A, B)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: [Hitch]) -> (A, B, C)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: [Hitch]) -> (A, B, C, D)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: [Hitch]) -> (A, B, C, D, E)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: [Hitch]) -> (A, B, C, D, E, F)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: [Hitch]) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: [String]) -> JsonArray? { return Sextant.shared.query(self, paths: paths.map { Hitch(string: $0) }) }
    @inlinable func query(values path: [String]) -> JsonArray? { return Sextant.shared.query(self, values: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(string path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(hitch path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(int path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(double path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(bool path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(date path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
}

public extension JsonElement {
    @inlinable func query(_ path: [Hitch]) -> JsonElement? { return Sextant.shared.query(self, element: path) }
    @inlinable func query(element path: [Hitch]) -> JsonElement? { return Sextant.shared.query(self, element: path) }

    @inlinable func query(paths: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(bool path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(date path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A, B>(_ path: [Hitch]) -> (A, B)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: [Hitch]) -> (A, B, C)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: [Hitch]) -> (A, B, C, D)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: [Hitch]) -> (A, B, C, D, E)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: [Hitch]) -> (A, B, C, D, E, F)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: [Hitch]) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: [String]) -> JsonArray? { return Sextant.shared.query(self, paths: paths.map { Hitch(string: $0) }) }
    @inlinable func query(values path: [String]) -> JsonArray? { return Sextant.shared.query(self, values: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(string path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(hitch path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(int path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(double path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(bool path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(date path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
}

public extension Array {
    @inlinable func query(paths: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(bool path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(date path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A, B>(_ path: [Hitch]) -> (A, B)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: [Hitch]) -> (A, B, C)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: [Hitch]) -> (A, B, C, D)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: [Hitch]) -> (A, B, C, D, E)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: [Hitch]) -> (A, B, C, D, E, F)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: [Hitch]) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: [String]) -> JsonArray? { return Sextant.shared.query(self, paths: paths.map { Hitch(string: $0) }) }
    @inlinable func query(values path: [String]) -> JsonArray? { return Sextant.shared.query(self, values: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(string path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(hitch path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(int path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(double path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(bool path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(date path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
}

public extension Dictionary {
    @inlinable func query(paths: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, paths: paths) }
    @inlinable func query(values path: [Hitch]) -> JsonArray? { return Sextant.shared.query(self, values: path) }
    @inlinable func query(_ path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(string path: [Hitch]) -> String? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(hitch path: [Hitch]) -> Hitch? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(int path: [Hitch]) -> Int? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(double path: [Hitch]) -> Double? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(bool path: [Hitch]) -> Bool? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(_ path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }
    @inlinable func query(date path: [Hitch]) -> Date? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<A, B>(_ path: [Hitch]) -> (A, B)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C>(_ path: [Hitch]) -> (A, B, C)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D>(_ path: [Hitch]) -> (A, B, C, D)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E>(_ path: [Hitch]) -> (A, B, C, D, E)? { return Sextant.shared.query(self, value: path) }
    @inlinable func query<A, B, C, D, E, F>(_ path: [Hitch]) -> (A, B, C, D, E, F)? { return Sextant.shared.query(self, value: path) }

    @inlinable func query<T: Decodable>(_ path: [Hitch]) -> T? { return Sextant.shared.query(self, values: path) }

    @inlinable func query(paths: [String]) -> JsonArray? { return Sextant.shared.query(self, paths: paths.map { Hitch(string: $0) }) }
    @inlinable func query(values path: [String]) -> JsonArray? { return Sextant.shared.query(self, values: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(string path: [String]) -> String? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(hitch path: [String]) -> Hitch? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(int path: [String]) -> Int? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(double path: [String]) -> Double? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(bool path: [String]) -> Bool? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(_ path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
    @inlinable func query(date path: [String]) -> Date? { return Sextant.shared.query(self, value: path.map { Hitch(string: $0) }) }
}

public extension Sextant {

    func query(_ root: JsonElement?,
               elements pathArray: [Hitch]) -> [JsonElement]? {
        var results = [JsonElement]()
        var numFails = 0
        for path in pathArray {
            if let values = query(root, elements: path) {
                results.append(contentsOf: values)
            } else {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        if results.isEmpty {
            return nil
        }
        return results
    }

    func query(_ root: JsonElement?,
               values pathArray: [Hitch]) -> JsonArray? {
        var results = JsonArray()
        var numFails = 0
        for path in pathArray {
            if let values = query(root, values: path) {
                results.append(contentsOf: values)
            } else {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        if results.isEmpty {
            return nil
        }
        return results
    }

    func query(_ root: JsonElement?,
               paths pathArray: [Hitch]) -> JsonArray? {
        var results = JsonArray()
        var numFails = 0
        for path in pathArray {
            if let values = query(root, paths: path) {
                results.append(contentsOf: values)
            } else {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        return results
    }

    func query(_ root: JsonAny,
               values pathArray: [Hitch]) -> JsonArray? {
        var results = JsonArray()
        var numFails = 0
        for path in pathArray {
            if let values = query(root, values: path) {
                results.append(contentsOf: values)
            } else {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        if results.isEmpty {
            return nil
        }
        return results
    }

    func query(_ root: JsonAny,
               paths pathArray: [Hitch]) -> JsonArray? {
        var results = JsonArray()
        var numFails = 0
        for path in pathArray {
            if let values = query(root, paths: path) {
                results.append(contentsOf: values)
            } else {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        return results
    }
}

// MARK: - All Results -> Decodable

public extension Sextant {
    @inlinable func query<T: Decodable>(_ root: String,
                                        values paths: [Hitch]) -> T? {
        // Not exactly performant, but this will work in all cases...
        if shouldUseSpanker {
            return root.parsed { jsonData in
                guard let results = query(jsonData, values: paths) else { return nil }
                guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
                return try? JSONDecoder().decode(T.self, from: resultsJson)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            guard let results = query(jsonData, values: paths) else { return nil }
            guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
            return try? JSONDecoder().decode(T.self, from: resultsJson)
        }
    }

    @inlinable func query<T: Decodable>(_ root: Hitch,
                                        values paths: [Hitch]) -> T? {
        // Not exactly performant, but this will work in all cases...
        if shouldUseSpanker {
            return root.parsed { jsonData in
                guard let results = query(jsonData, values: paths) else { return nil }
                guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
                return try? JSONDecoder().decode(T.self, from: resultsJson)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            guard let results = query(jsonData, values: paths) else { return nil }
            guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
            return try? JSONDecoder().decode(T.self, from: resultsJson)
        }
    }

    @inlinable func query<T: Decodable>(_ root: Data,
                                        values paths: [Hitch]) -> T? {
        // Not exactly performant, but this will work in all cases...
        if shouldUseSpanker {
            return root.parsed { jsonData in
                guard let results = query(jsonData, values: paths) else { return nil }
                guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
                return try? JSONDecoder().decode(T.self, from: resultsJson)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            guard let results = query(jsonData, values: paths) else { return nil }
            guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
            return try? JSONDecoder().decode(T.self, from: resultsJson)
        }
    }

    @inlinable func query<T: Decodable>(_ root: JsonAny,
                                        values paths: [Hitch]) -> T? {
        // Not exactly performant, but this will work in all cases...
        guard let results = query(root, values: paths) else { return nil }
        guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
        return try? JSONDecoder().decode(T.self, from: resultsJson)
    }

    @inlinable func query<T: Decodable>(_ root: JsonElement,
                                        values paths: [Hitch]) -> T? {
        // Not exactly performant, but this will work in all cases...
        guard let results = query(root, values: paths) else { return nil }
        guard let resultsJson = try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys, .fragmentsAllowed]) else { return nil }
        return try? JSONDecoder().decode(T.self, from: resultsJson)
    }
}

// MARK: - All Results -> JsonArray

public extension Sextant {
    @inlinable func query(_ root: String,
                          values pathArray: [Hitch]) -> JsonArray? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)
        }
    }

    @inlinable func query(_ root: Hitch,
                          values pathArray: [Hitch]) -> JsonArray? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)
        }
    }

    @inlinable func query(_ root: Data,
                          values pathArray: [Hitch]) -> JsonArray? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)
        }
    }

    @inlinable func query(_ root: String,
                          paths pathArray: [Hitch]) -> JsonArray? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, paths: pathArray)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, paths: pathArray)
        }
    }

    @inlinable func query(_ root: Hitch,
                          paths pathArray: [Hitch]) -> JsonArray? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, paths: pathArray)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, paths: pathArray)
        }
    }

    @inlinable func query(_ root: Data,
                          paths pathArray: [Hitch]) -> JsonArray? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, paths: pathArray)
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, paths: pathArray)
        }
    }
}

// MARK: - All Results -> JsonElement

public extension Sextant {
    @inlinable func query(_ root: String,
                          elements pathArray: [Hitch]) -> [JsonElement]? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, elements: pathArray)
            }
        } else {
            return nil
        }
    }

    @inlinable func query(_ root: Hitch,
                          elements pathArray: [Hitch]) -> [JsonElement]? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, elements: pathArray)
            }
        } else {
            return nil
        }
    }

    @inlinable func query(_ root: Data,
                          elements pathArray: [Hitch]) -> [JsonElement]? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, elements: pathArray)
            }
        } else {
            return nil
        }
    }
}

// MARK: - Results -> Tuple

public extension Sextant {
    @inlinable func query<A, B>(_ root: JsonAny, value pathArray: [Hitch]) -> (A, B)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B else {
            return nil
        }
        return (a, b)
    }
    @inlinable func query<A, B, C>(_ root: JsonAny, value pathArray: [Hitch]) -> (A, B, C)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C else {
            return nil
        }
        return (a, b, c)
    }
    @inlinable func query<A, B, C, D>(_ root: JsonAny, value pathArray: [Hitch]) -> (A, B, C, D)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D else {
            return nil
        }
        return (a, b, c, d)
    }
    @inlinable func query<A, B, C, D, E>(_ root: JsonAny, value pathArray: [Hitch]) -> (A, B, C, D, E)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E else {
            return nil
        }
        return (a, b, c, d, e)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: JsonAny, value pathArray: [Hitch]) -> (A, B, C, D, E, F)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E,
              let f = values.get(5) as? F else {
            return nil
        }
        return (a, b, c, d, e, f)
    }

    @inlinable func query<A, B>(_ root: JsonElement, value pathArray: [Hitch]) -> (A, B)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B else {
            return nil
        }
        return (a, b)
    }
    @inlinable func query<A, B, C>(_ root: JsonElement, value pathArray: [Hitch]) -> (A, B, C)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C else {
            return nil
        }
        return (a, b, c)
    }
    @inlinable func query<A, B, C, D>(_ root: JsonElement, value pathArray: [Hitch]) -> (A, B, C, D)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D else {
            return nil
        }
        return (a, b, c, d)
    }
    @inlinable func query<A, B, C, D, E>(_ root: JsonElement, value pathArray: [Hitch]) -> (A, B, C, D, E)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E else {
            return nil
        }
        return (a, b, c, d, e)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: JsonElement, value pathArray: [Hitch]) -> (A, B, C, D, E, F)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E,
              let f = values.get(5) as? F else {
            return nil
        }
        return (a, b, c, d, e, f)
    }

    @inlinable func query<A, B>(_ root: String, value pathArray: [Hitch]) -> (A, B)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B else {
            return nil
        }
        return (a, b)
    }
    @inlinable func query<A, B, C>(_ root: String, value pathArray: [Hitch]) -> (A, B, C)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C else {
            return nil
        }
        return (a, b, c)
    }
    @inlinable func query<A, B, C, D>(_ root: String, value pathArray: [Hitch]) -> (A, B, C, D)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D else {
            return nil
        }
        return (a, b, c, d)
    }
    @inlinable func query<A, B, C, D, E>(_ root: String, value pathArray: [Hitch]) -> (A, B, C, D, E)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E else {
            return nil
        }
        return (a, b, c, d, e)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: String, value pathArray: [Hitch]) -> (A, B, C, D, E, F)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E,
              let f = values.get(5) as? F else {
            return nil
        }
        return (a, b, c, d, e, f)
    }

    @inlinable func query<A, B>(_ root: Hitch, value pathArray: [Hitch]) -> (A, B)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B else {
            return nil
        }
        return (a, b)
    }
    @inlinable func query<A, B, C>(_ root: Hitch, value pathArray: [Hitch]) -> (A, B, C)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C else {
            return nil
        }
        return (a, b, c)
    }
    @inlinable func query<A, B, C, D>(_ root: Hitch, value pathArray: [Hitch]) -> (A, B, C, D)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D else {
            return nil
        }
        return (a, b, c, d)
    }
    @inlinable func query<A, B, C, D, E>(_ root: Hitch, value pathArray: [Hitch]) -> (A, B, C, D, E)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E else {
            return nil
        }
        return (a, b, c, d, e)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: Hitch, value pathArray: [Hitch]) -> (A, B, C, D, E, F)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E,
              let f = values.get(5) as? F else {
            return nil
        }
        return (a, b, c, d, e, f)
    }

    @inlinable func query<A, B>(_ root: Data, value pathArray: [Hitch]) -> (A, B)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B else {
            return nil
        }
        return (a, b)
    }
    @inlinable func query<A, B, C>(_ root: Data, value pathArray: [Hitch]) -> (A, B, C)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C else {
            return nil
        }
        return (a, b, c)
    }
    @inlinable func query<A, B, C, D>(_ root: Data, value pathArray: [Hitch]) -> (A, B, C, D)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D else {
            return nil
        }
        return (a, b, c, d)
    }
    @inlinable func query<A, B, C, D, E>(_ root: Data, value pathArray: [Hitch]) -> (A, B, C, D, E)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E else {
            return nil
        }
        return (a, b, c, d, e)
    }
    @inlinable func query<A, B, C, D, E, F>(_ root: Data, value pathArray: [Hitch]) -> (A, B, C, D, E, F)? {
        guard let values: JsonArray = query(root, values: pathArray) else { return nil }
        guard let a = values.get(0) as? A,
              let b = values.get(1) as? B,
              let c = values.get(2) as? C,
              let d = values.get(3) as? D,
              let e = values.get(4) as? E,
              let f = values.get(5) as? F else {
            return nil
        }
        return (a, b, c, d, e, f)
    }
}

// MARK: - First Result -> String

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value pathArray: [Hitch]) -> String? {
        return query(root, values: pathArray)?.first?.toString()
    }

    @inlinable func query(_ root: JsonElement,
                          value pathArray: [Hitch]) -> String? {
        return query(root, values: pathArray)?.first?.toString()
    }

    @inlinable func query(_ root: String,
                          value pathArray: [Hitch]) -> String? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toString()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toString()
        }
    }

    @inlinable func query(_ root: Hitch,
                          value pathArray: [Hitch]) -> String? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toString()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toString()
        }
    }

    @inlinable func query(_ root: Data,
                          value pathArray: [Hitch]) -> String? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toString()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toString()
        }
    }
}

// MARK: - First Result -> Hitch

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value pathArray: [Hitch]) -> Hitch? {
        return query(root, values: pathArray)?.first?.toHitch()
    }

    @inlinable func query(_ root: JsonElement,
                          value pathArray: [Hitch]) -> Hitch? {
        return query(root, values: pathArray)?.first?.toHitch()
    }

    @inlinable func query(_ root: String,
                          value pathArray: [Hitch]) -> Hitch? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toHitch()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toHitch()
        }
    }

    @inlinable func query(_ root: Hitch,
                          value pathArray: [Hitch]) -> Hitch? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toHitch()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toHitch()
        }
    }

    @inlinable func query(_ root: Data,
                          value pathArray: [Hitch]) -> Hitch? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toHitch()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toHitch()
        }
    }
}

// MARK: - First Result -> Int

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value pathArray: [Hitch]) -> Int? {
        return query(root, values: pathArray)?.first?.toInt()
    }

    @inlinable func query(_ root: JsonElement,
                          value pathArray: [Hitch]) -> Int? {
        return query(root, values: pathArray)?.first?.toInt()
    }

    @inlinable func query(_ root: String,
                          value pathArray: [Hitch]) -> Int? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toInt()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toInt()
        }
    }

    @inlinable func query(_ root: Hitch,
                          value pathArray: [Hitch]) -> Int? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toInt()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toInt()
        }
    }

    @inlinable func query(_ root: Data,
                          value pathArray: [Hitch]) -> Int? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toInt()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toInt()
        }
    }
}

// MARK: - First Result -> Double

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value pathArray: [Hitch]) -> Double? {
        return query(root, values: pathArray)?.first?.toDouble()
    }

    @inlinable func query(_ root: JsonElement,
                          value pathArray: [Hitch]) -> Double? {
        return query(root, values: pathArray)?.first?.toDouble()
    }

    @inlinable func query(_ root: String,
                          value pathArray: [Hitch]) -> Double? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toDouble()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toDouble()
        }
    }

    @inlinable func query(_ root: Hitch,
                          value pathArray: [Hitch]) -> Double? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toDouble()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toDouble()
        }
    }

    @inlinable func query(_ root: Data,
                          value pathArray: [Hitch]) -> Double? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toDouble()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toDouble()
        }
    }
}

// MARK: - First Result -> Bool

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value pathArray: [Hitch]) -> Bool? {
        return query(root, values: pathArray)?.first?.toBool()
    }

    @inlinable func query(_ root: JsonElement,
                          value pathArray: [Hitch]) -> Bool? {
        return query(root, values: pathArray)?.first?.toBool()
    }

    @inlinable func query(_ root: String,
                          value pathArray: [Hitch]) -> Bool? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toBool()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toBool()
        }
    }

    @inlinable func query(_ root: Hitch,
                          value pathArray: [Hitch]) -> Bool? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toBool()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toBool()
        }
    }

    @inlinable func query(_ root: Data,
                          value pathArray: [Hitch]) -> Bool? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toBool()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toBool()
        }
    }
}

// MARK: - First Result -> Date

public extension Sextant {
    @inlinable func query(_ root: JsonAny,
                          value pathArray: [Hitch]) -> Date? {
        return query(root, values: pathArray)?.first?.toDate()
    }

    @inlinable func query(_ root: JsonElement,
                          value pathArray: [Hitch]) -> Date? {
        return query(root, values: pathArray)?.first?.toDate()
    }

    @inlinable func query(_ root: String,
                          value pathArray: [Hitch]) -> Date? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toDate()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toDate()
        }
    }

    @inlinable func query(_ root: Hitch,
                          value pathArray: [Hitch]) -> Date? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toDate()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toDate()
        }
    }

    @inlinable func query(_ root: Data,
                          value pathArray: [Hitch]) -> Date? {
        if shouldUseSpanker {
            return root.parsed { jsonData in
                return query(jsonData, values: pathArray)?.first?.toDate()
            }
        } else {
            guard let jsonData = root.jsonDeserialized() else { return nil }
            return query(jsonData, values: pathArray)?.first?.toDate()
        }
    }
}

// MARK: - First Result -> JsonElement

public extension Sextant {
    @inlinable func query(_ root: JsonElement,
                          element pathArray: [Hitch]) -> JsonElement? {
        return query(root, elements: pathArray)?.first
    }
}
