import Foundation
import Hitch

public typealias JsonAny = Any?

func error(_ error: String) {
    print("Error: " + error)
}

public enum ArrayPathCheck: Equatable {
    case handle
    case skip
    case error(String)
    
    public static func == (lhs: ArrayPathCheck, rhs: ArrayPathCheck) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true

        default:
            return lhs == rhs
        }
    }
}

public enum EvaluationStatus: Equatable {
    case done
    case aborted
    case error(_ error: String)
    
    public static func == (lhs: EvaluationStatus, rhs: EvaluationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true

        default:
            return lhs == rhs
        }
    }
}

extension String {
    
    func query(path: Hitch) -> JsonAny {
        guard let jsonData = self.data(using: .utf8) else { return nil }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { return nil }
        
        return Sextant.shared.query(object: jsonObject,
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
    
    public func query(object: JsonAny,
                      path: Hitch) -> [JsonAny] {
        guard let path = cachedPath(query: path) else { return [] }
        
        
        
        return []
    }
    
}
