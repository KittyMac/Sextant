import Foundation
import Hitch

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
    
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        
        if isLeaf() {
            let op = evaluationContext.forUpdate ? parentPath : Path.nullPath()
            
            return evaluationContext.add(path: rootToken,
                                         operation: op,
                                         jsonObject: jsonObject)
        }
        
        if let next = next {
            return next.evaluate(currentPath: rootToken,
                                 parentPath: parentPath,
                                 jsonObject: jsonObject,
                                evaluationContext: evaluationContext)
        }
        
        return .error("root path token is leaf but next is nil")
    }
}


/*
- (id <SMJPathTokenAppender>)pathTokenAppender
{
	return self;
}

- (SMJPathToken *)tail
{
	return _tail;
}

- (void)setTail:(SMJPathToken *)tail
{
	_tail = tail;
}



#pragma mark - SMJRootPathToken - Properties

- (BOOL)isFunctionPath
{
	return [_tail isKindOfClass:[SMJFunctionPathToken class]];
}



#pragma mark - SMJRootPathToken - SMJPathToken

- (SMJEvaluationStatus)evaluateWithCurrentPath:(NSString *)currentPath parentPathRef:(SMJPathRef *)pathRef jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	if (self.leaf)
	{
		SMJPathRef *op = context.forUpdate ? pathRef : [SMJPathRef pathRefNull];
		
		if ([context addResult:_rootToken operation:op jsonObject:jsonObject] == SMJEvaluationContextStatusAborted)
			return SMJEvaluationStatusAborted;
		
		return SMJEvaluationStatusDone;
	}
	else
	{
		return [self.next evaluateWithCurrentPath:_rootToken parentPathRef:pathRef jsonObject:jsonObject evaluationContext:context error:error];
	}
}

- (NSInteger)tokenCount
{
	return _tokenCount;
}

- (BOOL)isTokenDefinite
{
	return YES;
}

- (NSString *)pathFragment
{
	return _rootToken;
}

@end


NS_ASSUME_NONNULL_END
*/
