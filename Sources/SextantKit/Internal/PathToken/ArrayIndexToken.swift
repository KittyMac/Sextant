import Foundation
import HitchKit
import SpankerKit

class ArrayIndexToken: ArrayPathToken {
    let indexOperation: ArrayIndexOperation

    init(operation: ArrayIndexOperation) {
        self.indexOperation = operation
    }

    @inlinable @inline(__always)
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        let checkResult = checkArray(currentPath: currentPath,
                                     jsonObject: jsonObject,
                                     evaluationContext: evaluationContext)
        switch checkResult {
        case .skip:
            if evaluationContext.add(path: currentPath,
                                     operation: NullPath.shared,
                                     jsonObject: nil) == .aborted {
                return .aborted
            }
            return .done
        case .error(let message):
            return .error(message)
        case .handle:
            guard let jsonArray = jsonObject as? JsonArray else {
                return .done
            }

            for index in indexOperation.indices {
                let result = handle(arrayIndex: index,
                                    currentPath: currentPath,
                                    jsonObject: jsonArray,
                                    evaluationContext: evaluationContext)

                switch result {
                case .error, .aborted:
                    return result
                default:
                    break
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
        let checkResult = checkArray(currentPath: currentPath,
                                     jsonElement: jsonElement,
                                     evaluationContext: evaluationContext)
        switch checkResult {
        case .skip:
            if evaluationContext.add(path: currentPath,
                                     operation: NullPath.shared,
                                     jsonObject: nil) == .aborted {
                return .aborted
            }
            return .done
        case .error(let message):
            return .error(message)
        case .handle:
            guard jsonElement.type == .array else {
                return .done
            }

            for index in indexOperation.indices {
                let result = handle(arrayIndex: index,
                                    currentPath: currentPath,
                                    jsonElement: jsonElement,
                                    evaluationContext: evaluationContext)

                switch result {
                case .error, .aborted:
                    return result
                default:
                    break
                }
            }
        }

        return .done
    }

    override func isTokenDefinite() -> Bool {
        return indexOperation.isSingleIndexOperation()
    }

    override func pathFragment() -> String {
        return indexOperation.description
    }
}
