import Foundation
import Hitch
import Spanker

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

public final class Sextant {
    public static let shared = Sextant()
    private init() { }

    public var shouldCachePaths = true

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
