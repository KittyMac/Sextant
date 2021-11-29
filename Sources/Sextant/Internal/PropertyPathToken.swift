import Foundation
import Hitch

class PropertyPathToken: PathToken {
    var properties: [Hitch]
    var wrap: UInt8
    
    init?(properties: [Hitch],
          wrap: UInt8) {
        if properties.count == 0 {
            error("Empty properties")
            return nil
        }
        
        self.properties = properties
        self.wrap = wrap
    }
    
    func singlePropertyCase() -> Bool {
        return properties.count == 1
    }
    
    func multiPropertyMergeCase() -> Bool {
        return isLeaf() && properties.count > 1
    }
    
    func multiPropertyIterationCase() -> Bool {
        // Semantics of this case is the same as semantics of ArrayPathToken with INDEX_SEQUENCE operation.
        return isLeaf() == false && properties.count > 1
    }
    
    func pathFragment() -> String {
        return "[\(properties.joined(delimiter: .comma, wrap: wrap))]"
    }
    
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        
        guard let jsonObject = jsonObject as? [String: JsonAny] else {
            if isUpstreamDefinite() == false {
                return .done
            }
            let m = (jsonObject == nil) ? "null" : jsonObject.debugDescription
            return .error("Expected to find an object with property \(pathFragment()) in path \(currentPath) but found '\(m)'. This is not a json object.")
        }
        
        if singlePropertyCase() || multiPropertyMergeCase() {
            return handle(properties: properties,
                          currentPath: currentPath,
                          jsonObject: jsonObject,
                          evaluationContext: evaluationContext)
        }
        
        if multiPropertyIterationCase() == false {
            return .error("internal error (need to be multi property iteration case)")
        }
        
        for property in properties {
            let result = handle(properties: [property],
                                currentPath: currentPath,
                                jsonObject: jsonObject,
                                evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }
        
        return .done
    }
    
    override func isTokenDefinite() -> Bool {
        // in case of leaf multiprops will be merged, so it's kinda definite
        return singlePropertyCase() || multiPropertyMergeCase()
    }
}

/*

#pragma mark - SMJPropertyPathToken - SMJPathToken

- (SMJEvaluationStatus)evaluateWithCurrentPath:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	// Can't assert it in ctor because isLeaf() could be changed later on.
	//assert onlyOneIsTrueNonThrow(singlePropertyCase(), multiPropertyMergeCase(), multiPropertyIterationCase());
	
	if ([jsonObject isKindOfClass:[NSDictionary class]] == NO)
	{
		if (self.upstreamDefinite == NO)
		{
			return SMJEvaluationStatusDone;
		}
		else
		{
			NSString *m = (jsonObject == nil ? @"null" : [[jsonObject class] description]);
			
			SMSetError(error, 1, @"Expected to find an object with property %@ in path %@ but found '%@'. This is not a json object.", self.pathFragment, currentPath, m);
			
			return SMJEvaluationStatusError;
		}
	}
	
	if (self.singlePropertyCase || self.multiPropertyMergeCase)
	{
		return [self handleObjectPropertyWithCurrentPathString:currentPath jsonObject:jsonObject evaluationContext:context properties:_properties error:error];
	}
	
	if (self.multiPropertyIterationCase == NO)
	{
		SMSetError(error, 2, @"internal error (need to be multi property iteration case)");
		return SMJEvaluationStatusError;
	}
	
	for (NSString *property in _properties)
	{
		SMJEvaluationStatus result = [self handleObjectPropertyWithCurrentPathString:currentPath jsonObject:jsonObject evaluationContext:context properties:@[ property ] error:error];
		
		if (result == SMJEvaluationStatusError)
			return SMJEvaluationStatusError;
		else if (result == SMJEvaluationStatusAborted)
			return SMJEvaluationStatusAborted;
	}

	return SMJEvaluationStatusDone;
}
- (NSString *)pathFragment
{
	return [NSString stringWithFormat:@"[%@]", [SMJUtils stringByJoiningStrings:_properties delimiter:@"," wrap:_stringDelimiter]];
}

@end


NS_ASSUME_NONNULL_END
*/
