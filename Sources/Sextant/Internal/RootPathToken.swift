import Foundation
import Hitch

public class RootPathToken: PathToken {
    weak var tail: PathToken?
    var tokenCount = 0
    var rootToken = Hitch(capacity: 512)
    
    init(root: UInt8) {
        rootToken.append(root)
        tokenCount += 1
        
        super.init()
        tail = self
    }
    
    func isRootPath() -> Bool {
        return rootToken[0] == UInt8.dollarSign
    }
    
    func append(token: PathToken) -> PathToken {
        tail = tail?.append(tail: token)
        tokenCount += 1
        return self
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
