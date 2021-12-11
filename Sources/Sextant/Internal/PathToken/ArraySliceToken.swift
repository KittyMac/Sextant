import Foundation
import Hitch

class ArraySliceToken: PathToken {
    let operation: ArraySliceOperation

    init(operation: ArraySliceOperation) {
        self.operation = operation
    }

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

            for i in from..<to {
                let result = handle(arrayIndex: i,
                                    currentPath: currentPath,
                                    jsonObject: jsonObject,
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
