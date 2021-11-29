import Foundation
import Hitch

public class CompiledPath: Path {
    var root: RootPathToken
    
    init(root: RootPathToken) {
        self.root = root
        super.init(parent: nil)
    }
    
    override func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext? {
        fatalError("TO BE IMPLEMENTED")
    }
    
    override func isDefinite() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        //return root.isTokenDefinite()
    }
    
    override func isFunctionPath() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        //return root.
    }
    
    override func isRootPath() -> Bool {
        return root.isRootPath()
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

- (nullable id <SMJEvaluationContext>)evaluateJsonObject:(id)jsonObject rootJsonObject:(id)rootJsonObject configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	return [self evaluateJsonObject:jsonObject rootJsonObject:rootJsonObject configuration:configuration forUpdate:NO error:error];
}

- (nullable id <SMJEvaluationContext>)evaluateJsonObject:(id)jsonObject rootJsonObject:(id)rootJsonObject configuration:(SMJConfiguration *)configuration forUpdate:(BOOL)forUpdate error:(NSError **)error
{
	//if (logger.isDebugEnabled()) {
	//	logger.debug("Evaluating path: {}", toString());
	//}
	
	SMJEvaluationContextImpl *context = [[SMJEvaluationContextImpl alloc] initWithPath:self rootJsonObject:rootJsonObject configuration:configuration forUpdate:forUpdate];
	SMJPathRef				 *op = context.forUpdate ?  [SMJPathRef pathRefWithRootObject:rootJsonObject] : [SMJPathRef pathRefNull];

	SMJEvaluationStatus result = [_root evaluateWithCurrentPath:@"" parentPathRef:op jsonObject:jsonObject evaluationContext:context error:error];
	
	if (result == SMJEvaluationStatusError)
		return nil;
	
	return context;
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
