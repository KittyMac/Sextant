import Foundation
import Hitch
import Spanker

struct CompiledPath: Path {
    let parent: JsonAny
    var root: RootPathToken
    let rootPath: Bool

    var currentPathEmpty = Hitch(capacity: 128)

    var evaluationContext: EvaluationContext?

    init(root: RootPathToken, isRootPath: Bool) {
        parent = root
        rootPath = isRootPath

        self.root = root
        self.root = invertScannerFunctionRelationshipWithToken(path: root)

        evaluationContext = EvaluationContext(path: self,
                                              rootJsonObject: JsonElement.null,
                                              options: EvaluationOptions.default)
    }

    private func invertScannerFunctionRelationshipWithToken(path: RootPathToken) -> RootPathToken {

        guard path.isFunctionPath() else { return path }
        guard path.next as? ScanPathToken != nil else { return path }

        var token: PathToken? = path
        var prior: PathToken?

        while token != nil && (token as? FunctionPathToken) == nil {
            prior = token
            token = token?.next
        }

        // Invert the relationship $..path.function() to $.function($..path)
        if let token = token as? FunctionPathToken {
            prior?.next = nil
            path.tail = prior

            // Now generate a new parameter from our path
            let newPath = CompiledPath(root: path, isRootPath: true)
            let newParameter = Parameter(path: newPath)

            token.functionParams = [newParameter]

            let functionRoot = RootPathToken(root: .dollarSign)

            functionRoot.tail = token
            functionRoot.next = token

            return functionRoot
        }

        return path
    }

    @inlinable @inline(__always)
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext? {
        guard let evaluationContext = self.evaluationContext else { return nil }

        let path = options.contains(.updateOperation) ?
            newPath(rootObject: rootJsonObject, options: options) :
            NullPath.shared

        evaluationContext.reset(rootJsonObject: rootJsonObject,
                                options: options)

        let result = root.evaluate(currentPath: currentPathEmpty,
                                   parentPath: path,
                                   jsonObject: jsonObject,
                                   evaluationContext: evaluationContext)
        switch result {
        case .error(let message):
            error("\(message)")
            return nil
        default:
            return evaluationContext
        }
    }

    @inlinable @inline(__always)
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext? {
        guard let evaluationContext = self.evaluationContext else { return nil }

        let path = options.contains(.updateOperation) ?
            newPath(rootObject: rootJsonElement, options: options) :
            NullPath.shared

        evaluationContext.reset(rootJsonElement: rootJsonElement,
                                options: options)

        let result = root.evaluate(currentPath: currentPathEmpty,
                                   parentPath: path,
                                   jsonElement: jsonElement,
                                   evaluationContext: evaluationContext)
        switch result {
        case .error(let message):
            error("\(message)")
            return nil
        default:
            return evaluationContext
        }
    }

    @inlinable @inline(__always)
    func isDefinite() -> Bool {
        return root.isPathDefinite()
    }

    @inlinable @inline(__always)
    func isFunctionPath() -> Bool {
        return root.isFunctionPath()
    }

    @inlinable @inline(__always)
    func isRootPath() -> Bool {
        return rootPath
    }

    var description: String {
        return root.description
    }
}
