import Foundation
import Hitch
import Spanker

struct CompiledPath: Path {
    let parent: JsonAny
    var root: RootPathToken
    let rootPath: Bool

    init(root: RootPathToken, isRootPath: Bool) {
        parent = root
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

    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext? {
        let context = EvaluationContext(path: self,
                                        rootJsonObject: rootJsonObject,
                                        options: options)

        let op = nullPath()

        let result = root.evaluate(currentPath: Hitch.empty,
                                   parentPath: op,
                                   jsonObject: jsonObject,
                                   evaluationContext: context)
        switch result {
        case .error(let message):
            error("\(message)")
            return nil
        default:
            return context
        }
    }

    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext? {
        let context = EvaluationContext(path: self,
                                        rootJsonElement: rootJsonElement,
                                        options: options)

        let op = nullPath()

        let result = root.evaluate(currentPath: Hitch.empty,
                                   parentPath: op,
                                   jsonElement: jsonElement,
                                   evaluationContext: context)
        switch result {
        case .error(let message):
            error("\(message)")
            return nil
        default:
            return context
        }
    }

    func isDefinite() -> Bool {
        return root.isPathDefinite()
    }

    func isFunctionPath() -> Bool {
        return root.isFunctionPath()
    }

    func isRootPath() -> Bool {
        return rootPath
    }

    var description: String {
        return root.description
    }
}
