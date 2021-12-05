import Foundation
import Hitch

class ValueNode: CustomStringConvertible {
    var description: String {
        fatalError("needs to be overwritten")
    }
    
    var literalValue: Hitch? {
        return nil
    }
    
    var typeName: Hitch {
        fatalError("needs to be overwritten")
    }
    
    func evaluate(context: PredicateContext) -> ValueNode? {
        fatalError("needs to be overwritten")
    }
}

/*
- (SMJEqualityResult)isEqual:(SMJValueNode *)node withError:(NSError **)error
{
	if ([[self class] isEqual:[node class]] == NO)
		return SMJEqualityDiffer;
		
	id obj1 = [self comparableUnderlayingObjectWithError:error];
	id obj2 = [node comparableUnderlayingObjectWithError:error];
	
	if (!obj1 || !obj2)
		return SMJEqualityError;
	
	return ([obj1 isEqual:obj2] ? SMJEqualitySame : SMJEqualityDiffer);
}

- (SMJComparisonResult)compare:(SMJValueNode *)node withError:(NSError **)error
{
	id obj1 = [self comparableUnderlayingObjectWithError:error];
	id obj2 = [node comparableUnderlayingObjectWithError:error];
	
	if (!obj1 || !obj2)
		return SMJComparisonError;

	if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]])
	{
		NSNumber *number1 = [SMJUtils numberWithString:obj1];
		NSNumber *number2 = [SMJUtils numberWithString:obj2];

		if (number1 && number2)
			return convertComparison([number1 compare:number2]);
		else
			return convertComparison([(NSString *)obj1 compare:(NSString *)obj2]);
	}
	else if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSNumber class]])
	{
		NSNumber *number1 = [SMJUtils numberWithString:obj1];
		
		if (number1)
			return convertComparison([number1 compare:(NSNumber *)obj2]);
		else
			return convertComparison([obj1 compare:[(NSNumber *)obj2 stringValue]]);
	}
	else if ([obj1 isKindOfClass:[NSNumber class]] && [obj2 isKindOfClass:[NSString class]])
	{
		NSNumber *number2 = [SMJUtils numberWithString:obj2];
		
		if (number2)
			return convertComparison([(NSNumber *)obj1 compare:number2]);
		else
			return convertComparison([[(NSNumber *)obj1 stringValue] compare:obj2]);
	}
	else if ([obj1 isKindOfClass:[NSNumber class]] && [obj2 isKindOfClass:[NSNumber class]])
	{
		return convertComparison([(NSNumber *)obj1 compare:(NSNumber *)obj2]);
	}
	else
	{
		return ([obj1 isEqual:obj2] ? SMJComparisonSame : SMJComparisonDiffer);
	}
}

- (nullable id)underlayingObjectWithError:(NSError **)error
{
	NSAssert(NO, @"need to be overwritten");
	return nil;
}

- (nullable id)comparableUnderlayingObjectWithError:(NSError **)error
{
	return [self underlayingObjectWithError:error];
}

@end

#pragma mark - C Tools

static SMJComparisonResult convertComparison(NSComparisonResult result)
{
	switch (result)
	{
		case NSOrderedAscending:
			return SMJComparisonDifferLessThan;
			
		case NSOrderedSame:
			return SMJComparisonSame;
			
		case NSOrderedDescending:
			return SMJComparisonDifferGreaterThan;
	}
}


NS_ASSUME_NONNULL_END
*/
