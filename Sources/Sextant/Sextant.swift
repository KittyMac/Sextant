import Foundation
import Hitch
import Spanker

public typealias JsonAny = Any?
public typealias JsonArray = [JsonAny]
public typealias JsonDictionary = [String: JsonAny]

extension JsonAny {
    @inlinable @inline(__always)
    func toDouble() -> Double? {
        switch self {
        case let double as Double:
            return double
        case let int as Int:
            return Double(int)
        default:
            return nil
        }
    }

    @inlinable @inline(__always)
    func toInt() -> Int? {
        switch self {
        case let double as Double:
            return Int(double)
        case let int as Int:
            return int
        default:
            return nil
        }
    }

    @inlinable @inline(__always)
    func toString() -> String? {
        switch self {
        case let string as String:
            return string
        case let hitch as Hitch:
            return hitch.description
        case let halfHitch as HalfHitch:
            return halfHitch.description
        default:
            return nil
        }
    }

    @inlinable @inline(__always)
    func toHitch() -> Hitch? {
        switch self {
        case let string as String:
            return string.hitch()
        case let hitch as Hitch:
            return hitch
        case let halfHitch as HalfHitch:
            return halfHitch.hitch()
        default:
            return nil
        }
    }

    @inlinable @inline(__always)
    func toHalfHitch() -> HalfHitch? {
        switch self {
        case let string as String:
            return string.hitch().halfhitch()
        case let hitch as Hitch:
            return hitch.halfhitch()
        case let halfHitch as HalfHitch:
            return halfHitch
        default:
            return nil
        }
    }
}

@usableFromInline
struct EvaluationOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let exportPaths = EvaluationOptions(rawValue: 1 << 0)
    public static let exportValues = EvaluationOptions(rawValue: 1 << 1)

    public static let `default`: EvaluationOptions = [.exportValues]
}

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
    func jsonDeserialized() -> JsonAny {
        return self.dataNoCopy().jsonDeserialized()
    }
}

public extension String {
    @inlinable
    func jsonDeserialized() -> JsonAny {
        return self.data(using: .utf8)?.jsonDeserialized()
    }
}

public extension Data {
    @inlinable
    func jsonDeserialized() -> JsonAny {
        return try? JSONSerialization.jsonObject(with: self, options: [.allowFragments])
    }
}

public final class Sextant {
    public static let shared = Sextant()
    private init() { }

    public var shouldCachePaths = true
    public var shouldUseSpanker = true

    var cachedPaths = [Hitch: Path]()
    private var lock = NSLock()

    func cachedPath(query: Hitch) -> Path? {
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
}
