import Foundation
import Hitch

class ArrayPathToken: PathToken {
    
}


/*
#import "SMJArrayPathToken.h"


NS_ASSUME_NONNULL_BEGIN


#pragma mark - Macros

#define SMSetError(Error, Code, Message, ...) \
	do { \
		if ((Error) && *(Error) == nil) {\
			NSString *___message = [NSString stringWithFormat:(Message), ## __VA_ARGS__];\
			*(Error) = [NSError errorWithDomain:@"SMJArrayPathTokenErrorDomain" code:(Code) userInfo:@{ NSLocalizedDescriptionKey : ___message }]; \
		} \
	} while (0)



#pragma mark - SMJArrayPathToken

@implementation SMJArrayPathToken


- (SMJArrayPathCheck)checkArrayWithCurrentPathString:(NSString *)currentPath jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
	if (jsonObject == nil)
	{
		if (self.upstreamDefinite == NO)
		{
			return SMJArrayPathCheckSkip;
		}
		else
		{
			SMSetError(error, 1, @"The path %@ is null", currentPath);
			return SMJArrayPathCheckError;
		}
	}
	
	if ([jsonObject isKindOfClass:[NSArray class]] == NO)
	{
		if (self.upstreamDefinite == NO)
		{
			return SMJArrayPathCheckSkip;
		}
		else
		{
			SMSetError(error, 2, @"Filter: %@ can only be applied to arrays. Current context is: %@", [self stringValue], jsonObject);
			return SMJArrayPathCheckError;
		}
	}
	
	return SMJArrayPathCheckHandle;
}

@end


NS_ASSUME_NONNULL_END
*/
