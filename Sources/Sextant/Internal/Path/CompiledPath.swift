import Foundation
import Hitch

class CompiledPath: Path {
    var root: RootPathToken
    let rootPath: Bool
    
    init(root: RootPathToken, isRootPath: Bool) {
        rootPath = isRootPath
        self.root = root
        super.init(parent: nil)
        
        self.root = invertScannerFunctionRelationshipWithToken(path: root)
    }
    
    private func invertScannerFunctionRelationshipWithToken(path: RootPathToken) -> RootPathToken {
        
        guard path.isFunctionPath() else { return path }
        guard path.next as? ScanPathToken != nil else { return path }
        
        var token: PathToken? = path
        var prior: PathToken? = nil
        
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
    
    override func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext? {
        let context = EvaluationContext(path: self,
                                        rootJsonObject: rootJsonObject)
        
        let op = context.forUpdate ? Path.newPath(rootObject: rootJsonObject) : Path.nullPath()
        
        let result = root.evaluate(currentPath: Hitch(),
                                   parentPath: op,
                                   jsonObject: jsonObject,
                                   evaluationContext: context)
        if result != .done {
            error("\(result)")
            return nil
        }
        
        return context
    }
    
    override func isDefinite() -> Bool {
        return root.isPathDefinite()
    }
    
    override func isFunctionPath() -> Bool {
        return root.isFunctionPath()
    }
    
    override func isRootPath() -> Bool {
        return rootPath
    }
    
    override var description: String {
        return root.description
    }
}
