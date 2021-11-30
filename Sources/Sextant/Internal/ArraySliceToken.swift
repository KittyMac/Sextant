import Foundation
import Hitch

class ArraySliceToken: PathToken {
    let operation: ArraySliceOperation
    
    init(operation: ArraySliceOperation) {
        self.operation = operation
    }
    
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        let checkResult = checkArray(currentPath: currentPath,
                                     jsonObject: jsonObject,
                                     evaluationContext: evaluationContext)
        switch checkResult {
        case .skip:
            return .done
        case .error(let message):
            return .error(message)
        case .handle:
            
            guard let array = jsonObject as? [JsonAny] else { return .error("Attempted slice operation on a non-Array value") }
            var from = operation.from ?? 0
            var to = operation.to ?? array.count
            
            from = max(0, from)
            to = min(array.count, to)
            
            if from >= to || array.count == 0 {
                return .done
            }
            
            for i in from..<to {
                let result = handle(arrayIndex: i,
                                    currentPath: currentPath,
                                    jsonObject: jsonObject,
                                    evaluationContext: evaluationContext)
                
                guard result == .done else { return result }
            }
            
            return .done
        }
    }
    
    override func isTokenDefinite() -> Bool {
        return false
    }
    
}


/*

#pragma mark - SMJArraySliceToken

#pragma mark - SMJArraySliceToken - SMJPathToken

- (SMJEvaluationStatus)evaluateWithCurrentPath:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	SMJArrayPathCheck checkResult = [self checkArrayWithCurrentPathString:currentPath jsonObject:jsonObject evaluationContext:context error:error];
	
	if (checkResult == SMJArrayPathCheckSkip)
		return SMJEvaluationStatusDone;
	else if (checkResult == SMJArrayPathCheckError)
		return SMJEvaluationStatusError;
	
	switch (_sliceOperation.operation)
	{
		case SMJSliceOperationFrom:
			return [self sliceFromWithOperation:_sliceOperation currentPathString:currentPath parentPathRef:parent jsonObject:jsonObject evaluationContext:context error:error];
			
		case SMJSliceOperationBetween:
			return [self sliceBetweenWithOperation:_sliceOperation currentPathString:currentPath parentPathRef:parent jsonObject:jsonObject evaluationContext:context error:error];
			
		case SMJSliceOperationTo:
			return [self sliceToWithOperation:_sliceOperation currentPathString:currentPath parentPathRef:parent jsonObject:jsonObject evaluationContext:context error:error];
	}
	
	return SMJEvaluationStatusDone;
}

- (BOOL)isTokenDefinite
{
	return NO;
}

- (NSString *)pathFragment
{
	return [_sliceOperation stringValue];
}



#pragma mark - SMJArraySliceToken - Helpers

- (SMJEvaluationStatus)sliceFromWithOperation:(SMJArraySliceOperation *)operation currentPathString:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	NSArray *array = jsonObject;
	NSInteger length = array.count;
	NSInteger from = operation.fromIndex;
	
	//calculate slice start from array length
	if (from < 0)
		from = length + from;
	
	from = MAX(0, from);
	
	//logger.debug("Slice from index on array with length: {}. From index: {} to: {}. Input: {}", length, from, length - 1, toString());
	
	if (length == 0 || from >= length)
		return SMJEvaluationStatusDone;
	
	for (NSInteger i = from; i < length; i++)
	{
		SMJEvaluationStatus result = [self handleArrayIndex:i currentPathString:currentPath jsonObject:jsonObject evaluationContext:context error:error];
		
		if (result == SMJEvaluationStatusError)
			return SMJEvaluationStatusError;
		else if (result == SMJEvaluationStatusAborted)
			return SMJEvaluationStatusAborted;
	}
	
	return SMJEvaluationStatusDone;
}

- (SMJEvaluationStatus)sliceBetweenWithOperation:(SMJArraySliceOperation *)operation currentPathString:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	NSArray *array = jsonObject;
	NSInteger length = array.count;
	NSInteger from = operation.fromIndex;
	NSInteger to = operation.toIndex;
	
	to = MIN(length, to);
	
	if (from >= to || length == 0)
	{
		return SMJEvaluationStatusDone;
	}
	
	//logger.debug("Slice between indexes on array with length: {}. From index: {} to: {}. Input: {}", length, from, to, toString());
	
	for (NSInteger i = from; i < to; i++)
	{
		SMJEvaluationStatus result = [self handleArrayIndex:i currentPathString:currentPath jsonObject:jsonObject evaluationContext:context error:error];
		
		if (result == SMJEvaluationStatusError)
			return SMJEvaluationStatusError;
		else if (result == SMJEvaluationStatusAborted)
			return SMJEvaluationStatusAborted;
	}
	
	return SMJEvaluationStatusDone;
}

- (SMJEvaluationStatus)sliceToWithOperation:(SMJArraySliceOperation *)operation currentPathString:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	NSArray		*array = jsonObject;
	NSInteger	length = array.count;
	
	if (length == 0)
		return SMJEvaluationStatusDone;
	
	NSInteger to = operation.toIndex;
	
	//calculate slice end from array length
	if (to < 0)
		to = length + to;
	
	to = MIN(length, to);
	
	//logger.debug("Slice to index on array with length: {}. From index: 0 to: {}. Input: {}", length, to, toString());
	
	for (NSInteger i = 0; i < to; i++)
	{
		SMJEvaluationStatus result = [self handleArrayIndex:i currentPathString:currentPath jsonObject:jsonObject evaluationContext:context error:error];
		
		if (result == SMJEvaluationStatusError)
			return SMJEvaluationStatusError;
		else if (result == SMJEvaluationStatusAborted)
			return SMJEvaluationStatusAborted;
	}
	
	return SMJEvaluationStatusDone;
}

@end


NS_ASSUME_NONNULL_END
*/
