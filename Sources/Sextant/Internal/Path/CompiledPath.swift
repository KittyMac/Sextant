import Foundation
import Hitch
import Spanker

struct CompiledPath: Path {
    @usableFromInline
    let parentAny: JsonAny

    @usableFromInline
    let parentDictionary: JsonDictionary? = nil

    @usableFromInline
    let parentArray: JsonArray? = nil

    @usableFromInline
    let parentElement: JsonElement? = nil

    var root: RootPathToken
    let rootPath: Bool

    init(root: RootPathToken, isRootPath: Bool) {
        parentAny = root
        rootPath = isRootPath

        self.root = root
        self.root = invertScannerFunctionRelationshipWithToken(path: root)
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

    @inlinable
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext? {
        let evaluationContext = EvaluationContext(path: self,
                                                  rootJsonObject: rootJsonObject,
                                                  options: options)

        let path = options.contains(.updateOperation) ?
            newPath(rootObject: rootJsonObject, options: options) :
            NullPath.shared

        let result = root.evaluate(currentPath: Hitch(capacity: 512),
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

    @inlinable
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext? {
        let evaluationContext = EvaluationContext(path: self,
                                                  rootJsonElement: rootJsonElement,
                                                  options: options)

        let path = options.contains(.updateOperation) ?
            newPath(rootElement: rootJsonElement, options: options) :
            NullPath.shared

        let result = root.evaluate(currentPath: Hitch(capacity: 512),
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

    @inlinable
    func isDefinite() -> Bool {
        return root.isPathDefinite()
    }

    @inlinable
    func isFunctionPath() -> Bool {
        return root.isFunctionPath()
    }

    @inlinable
    func isRootPath() -> Bool {
        return rootPath
    }

    var description: String {
        return root.description
    }
}
