import Foundation
import HitchKit
import SpankerKit

class ArraySliceToken: PathToken {
    let operation: ArraySliceOperation

    init(operation: ArraySliceOperation) {
        self.operation = operation
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
            return .done
        case .error(let message):
            return .error(message)
        case .handle:

            guard let array = jsonObject as? JsonArray else { return .error("Attempted slice operation on a non-Array value") }
            var from = operation.from ?? 0
            var to = operation.to ?? array.count
            var skip = operation.skip ?? 1

            if skip <= 0 {
                skip = 1
            }

            if from < 0 {
                from = array.count + from
            }
            if to < 0 {
                to = array.count + to
            }

            from = max(0, from)
            to = min(array.count, to)

            if from >= to || array.count == 0 {
                return .done
            }

            for i in stride(from: from, to: to, by: skip) {
                let result = handle(arrayIndex: i,
                                    currentPath: currentPath,
                                    jsonObject: array,
                                    evaluationContext: evaluationContext)

                guard result == .done else { return result }
            }

            return .done
        }
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
            return .done
        case .error(let message):
            return .error(message)
        case .handle:

            guard jsonElement.type == .array else { return .error("Attempted slice operation on a non-Array value") }
            var from = operation.from ?? 0
            var to = operation.to ?? jsonElement.count
            var skip = operation.skip ?? 1

            if skip <= 0 {
                skip = 1
            }

            if from < 0 {
                from = jsonElement.count + from
            }
            if to < 0 {
                to = jsonElement.count + to
            }

            from = max(0, from)
            to = min(jsonElement.count, to)

            if from >= to || jsonElement.count == 0 {
                return .done
            }

            for i in stride(from: from, to: to, by: skip) {
                let result = handle(arrayIndex: i,
                                    currentPath: currentPath,
                                    jsonElement: jsonElement,
                                    evaluationContext: evaluationContext)

                guard result == .done else { return result }
            }

            return .done
        }
    }

    override func isTokenDefinite() -> Bool {
        return false
    }

    override func pathFragment() -> String {
        return operation.description
    }
}
