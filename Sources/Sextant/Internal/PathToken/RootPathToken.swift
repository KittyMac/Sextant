import Foundation
import Hitch
import Spanker

final class RootPathToken: PathToken {
    weak var tail: PathToken?
    var tokenCount = 0
    var rootToken = Hitch(capacity: 1)

    init(root: UInt8) {
        rootToken.append(root)
        tokenCount = 1

        super.init()
        tail = self
    }

    func isRootPath() -> Bool {
        return rootToken[0] == UInt8.dollarSign
    }

    func isFunctionPath() -> Bool {
        return (tail as? FunctionPathToken) != nil
    }

    @discardableResult
    override func append(token: PathToken) -> PathToken {
        tail = tail?.append(tail: token)
        tokenCount += 1
        return self
    }

    @inlinable @inline(__always)
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        if let next = next {
            return next.evaluate(currentPath: rootToken,
                                 parentPath: parentPath,
                                 jsonObject: jsonObject,
                                 evaluationContext: evaluationContext)
        } else {
            return evaluationContext.add(path: rootToken,
                                         operation: NullPath.shared,
                                         jsonObject: jsonObject)
        }
    }

    @inlinable @inline(__always)
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonElement: JsonElement,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        if let next = next {
            return next.evaluate(currentPath: rootToken,
                                 parentPath: parentPath,
                                 jsonElement: jsonElement,
                                 evaluationContext: evaluationContext)
        } else {
            return evaluationContext.add(path: rootToken,
                                         operation: NullPath.shared,
                                         jsonElement: jsonElement)
        }
    }

    override func isTokenDefinite() -> Bool {
        return true
    }

    override func pathFragment() -> String {
        return rootToken.description
    }
}
