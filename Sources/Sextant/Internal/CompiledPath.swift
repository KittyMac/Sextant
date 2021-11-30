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
        
        _ = root.evaluate(currentPath: Hitch(),
                          parentPath: op,
                          jsonObject: jsonObject,
                          evaluationContext: context)
        
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
}

/*
#pragma mark - SMJCompiledPath - Helpers


- (SMJRootPathToken *)invertScannerFunctionRelationshipWithToken:(SMJRootPathToken *)path
{
	if (path.functionPath && [path.next isKindOfClass:[SMJScanPathToken class]])
	{
		SMJPathToken *token = path;
		SMJPathToken *prior = nil;
		
		while (((token = token.next) != nil) && ([token isKindOfClass:[SMJFunctionPathToken class]] == NO))
			prior = token;
		
		// Invert the relationship $..path.function() to $.function($..path)
		if ([token isKindOfClass:[SMJFunctionPathToken class]])
		{
			prior.next = nil;
			path.tail = prior;
			
			// Now generate a new parameter from our path
			SMJCompiledPath *newPath = [[SMJCompiledPath alloc] initWithRootPathToken:path isRootPath:YES];
			SMJParameter	*newParameter = [[SMJParameter alloc] initWithPath:newPath];
			
			[(SMJFunctionPathToken *)token setFunctionParams:@[ newParameter ]];
			
			SMJRootPathToken *functionRoot = [[SMJRootPathToken alloc] initWithRootToken:'$'];
			
			functionRoot.tail = token;
			functionRoot.next = token;
			
			return functionRoot;
		}
	}
	
	return path;
}




#pragma mark - SMJCompiledPath - SMJPath

- (NSString *)stringValue
{
	return [_root stringValue];
}

- (BOOL)isDefinite
{
	return _root.pathDefinite;
}

- (BOOL)isFunctionPath
{
	return _root.functionPath;
}

- (BOOL)isRootPath
{
	 return _isRootPath;
}

@end


NS_ASSUME_NONNULL_END
*/
