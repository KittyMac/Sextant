import Foundation
import Hitch
import Spanker

final class RootPathToken: PathToken {
    weak var tail: PathToken?
    var tokenCount = 0
    var rootToken = Hitch(capacity: 1)
    let isRootPathToken: Bool

    init(root: UInt8) {
        rootToken.append(root)
        tokenCount = 1

        isRootPathToken = root == UInt8.dollarSign

        super.init()
        tail = self
    }

    @inlinable
    func isRootPath() -> Bool {
        return isRootPathToken
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

    @inlinable
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        let rootPath = Hitch(capacity: 512)
        rootPath.append(rootToken)

        if let next = next {
            return next.evaluate(currentPath: rootPath,
                                 parentPath: parentPath,
                                 jsonObject: jsonObject,
                                 evaluationContext: evaluationContext)
        } else {

            let path = evaluationContext.options.contains(.updateOperation) ?
                parentPath :
                NullPath.shared

            return evaluationContext.add(path: rootPath,
                                         operation: path,
                                         jsonObject: jsonObject)
        }
    }

    @inlinable
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonElement: JsonElement,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        let rootPath = Hitch(capacity: 512)
        rootPath.append(rootToken)

        if let next = next {
            return next.evaluate(currentPath: rootPath,
                                 parentPath: parentPath,
                                 jsonElement: jsonElement,
                                 evaluationContext: evaluationContext)
        } else {

            let path = evaluationContext.options.contains(.updateOperation) ?
                parentPath :
                NullPath.shared

            return evaluationContext.add(path: rootPath,
                                         operation: path,
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
