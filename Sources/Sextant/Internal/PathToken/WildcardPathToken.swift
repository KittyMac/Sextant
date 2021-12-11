import Foundation
import Hitch

class WildcardPathToken: PathToken {

    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        if let dictionary = jsonObject as? JsonDictionary {
            for property in dictionary.keys {
                let result = handle(properties: [property.hitch()],
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
                                    jsonObject: jsonObject,
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
