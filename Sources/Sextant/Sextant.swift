import Foundation
import Hitch

public typealias JsonAny = Any?

func error(_ error: String) {
    print("Error: " + error)
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

extension String {
    func json(values path: Hitch) -> JsonAny {
        guard let jsonData = self.data(using: .utf8) else { return nil }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { return nil }
        
        return Sextant.shared.values(root: jsonObject,
                                     path: path)
    }
}

public final class Sextant {
    public static let shared = Sextant()
    private init() { }

    private var cachedPaths = [Hitch: Path]()
    
    private func cachedPath(query: Hitch) -> Path? {
        if let path = cachedPaths[query] {
            return path
        }
        
        guard let pathCompiler = PathCompiler(query: query) else { return nil }
        guard let path = pathCompiler.compile() else { return nil }
        
        cachedPaths[query] = path
        return path
    }
    
    public func values(root: JsonAny,
                       path: Hitch) -> [JsonAny] {
        guard let path = cachedPath(query: path) else { return [] }
        if let result = path.evaluate(jsonObject: root,
                                      rootJsonObject: root) {
            return result.valueResults
        }
        return []
    }
    
    public func paths(root: JsonAny,
                      path: Hitch) -> [JsonAny] {
        guard let path = cachedPath(query: path) else { return [] }
        if let result = path.evaluate(jsonObject: root,
                                      rootJsonObject: root) {
            return result.pathResults
        }
        return []
    }
    
}
