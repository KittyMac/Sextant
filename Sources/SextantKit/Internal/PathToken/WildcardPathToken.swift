import Foundation
import HitchKit
import SpankerKit

class WildcardPathToken: PathToken {

    @inlinable @inline(__always)
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        if let dictionary = jsonObject as? JsonDictionary {
            for property in dictionary.keys {
                let result = handle(property: Hitch(string: property),
                                    currentPath: currentPath,
                                    jsonObject: jsonObject,
                                    evaluationContext: evaluationContext)
                if result != .done {
                    return result
                }
            }
        } else if let array = jsonObject as? JsonArray {
            for idx in 0..<array.count {
                let result = handle(arrayIndex: idx,
                                    currentPath: currentPath,
                                    jsonObject: array,
                                    evaluationContext: evaluationContext)
                if result != .done {
                    return result
                }
            }
        }

        return .done
    }

    @inlinable @inline(__always)
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonElement: JsonElement,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        if jsonElement.type == .dictionary {
            for property in jsonElement.iterKeys {
                let result = handle(property: property.hitch(),
                                    currentPath: currentPath,
                                    jsonElement: jsonElement,
                                    evaluationContext: evaluationContext)
                if result != .done {
                    return result
                }
            }
        } else if jsonElement.type == .array {
            for idx in 0..<jsonElement.count {
                let result = handle(arrayIndex: idx,
                                    currentPath: currentPath,
                                    jsonElement: jsonElement,
                                    evaluationContext: evaluationContext)
                if result != .done {
                    return result
                }
            }
        }

        return .done
    }

    override func isTokenDefinite() -> Bool {
        return false
    }

    override func pathFragment() -> String {
        return "[*]"
    }
}
