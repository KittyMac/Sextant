import Foundation
import Hitch

final class FunctionPathToken: PathToken {
    var fragment: Hitch? = nil
    
    var functionName: Hitch? = nil
    var functionParams: [Parameter]? = nil
    
    init(fragment: Hitch) {
        self.fragment = Hitch(hitch: fragment).append(UInt8.parenOpen).append(UInt8.parenClose)
    }
    
    init(name: Hitch,
         parameters: [Parameter]) {
        self.functionName = name
        self.functionParams = parameters
    }
    
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        fatalError("TO BE IMPLEMENTED")
    }
    
    override func isTokenDefinite() -> Bool {
        return true
    }
    
    override func pathFragment() -> String {
        return "." + (fragment ?? "TO BE IMPLEMENTED").description
    }
}

/*
- (SMJEvaluationStatus)evaluateWithCurrentPath:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	id <SMJPathFunction> pathFunction = [SMJPathFunctionFactory pathFunctionForName:_functionName error:error];
	
	if (!pathFunction)
		return SMJEvaluationStatusError;
	
	[self evaluateParametersWithCurrentPathString:currentPath parentPathRef:parent jsonObject:jsonObject context:context];
	
	id result = [pathFunction invokeWithCurrentPathString:currentPath parentPath:parent jsonObject:jsonObject evaluationContext:context parameters:_functionParams error:error];
	
	if (!result)
		return SMJEvaluationStatusError;
	
	if ([context addResult:[NSString stringWithFormat:@"%@.%@", currentPath, _functionName] operation:parent jsonObject:result] == SMJEvaluationContextStatusAborted)
		return SMJEvaluationStatusAborted;
	
	if (self.leaf == NO)
		return [self.next evaluateWithCurrentPath:currentPath parentPathRef:parent jsonObject:result evaluationContext:context error:error];
	
	return SMJEvaluationStatusDone;
}

- (void)evaluateParametersWithCurrentPathString:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject context:(SMJEvaluationContextImpl *)context
{
	if (!_functionParams)
		return;
	
	for (SMJParameter *param in _functionParams)
	{
		if (param.evaluated)
			continue;
		
		switch (param.type)
		{
			case SMJParamTypePath:
			{
				SMJParamLateBinding lateBinding = ^ id _Nullable (SMJParameter *parameter, NSError **lateError) {
					
					id <SMJPath> path = parameter.path;
					id <SMJEvaluationContext> evaluationContext = [path evaluateJsonObject:context.rootJsonObject rootJsonObject:context.rootJsonObject configuration:context.configuration error:lateError];
					
					if (!evaluationContext)
						return nil;
					
					return [evaluationContext jsonObjectWithError:lateError];
				};
				
				param.lateBinding = lateBinding;
				param.evaluated = YES;
				
				break;
			}
			
			case SMJParamTypeJSON:
			{
				SMJParamLateBinding lateBinding = ^ id _Nullable (SMJParameter *parameter, NSError **lateError) {
					NSString	*jsonString = parameter.jsonString;
					NSData		*jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
					
					if (!jsonData)
						return nil;
					
					return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:lateError];
				};

				param.lateBinding = lateBinding;
				param.evaluated = YES;
				
				break;
			}
		}
	}
}



- (BOOL)isTokenDefinite
{
	return YES;
}

- (NSString *)pathFragment
{
	return [@"." stringByAppendingString:_pathFragment];
}

@end


NS_ASSUME_NONNULL_END
*/
