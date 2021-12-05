import Foundation
import Hitch

class NullNode: ValueNode {
    
}


/*
#pragma mark SMJNullNode

@implementation SMJNullNode

- (instancetype)initInternal
{
	self = [super init];
	
	return self;
}

- (NSString *)stringValue
{
	return @"null";
}

- (NSString *)typeName
{
	return @"null";
}

- (SMJEqualityResult)isEqual:(SMJValueNode *)node withError:(NSError **)error
{
	return ([node isKindOfClass:[SMJNullNode class]] ? SMJEqualitySame : SMJEqualityDiffer);
}

- (SMJComparisonResult)compare:(SMJValueNode *)node withError:(NSError **)error
{
	return ([node isKindOfClass:[SMJNullNode class]] ? SMJComparisonSame : SMJComparisonDiffer);
}

- (NSNull *)underlayingObjectWithError:(NSError **)error
{
	return [NSNull null];
}

@end
*/
