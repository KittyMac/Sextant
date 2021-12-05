import Foundation
import Hitch

class NumberNode: ValueNode {
    
}


/*
#pragma mark SMJNumberNode

@implementation SMJNumberNode
{
	NSNumber *_value;
}

- (instancetype)initWithString:(NSString *)string
{
	self = [super init];
	
	if (self)
	{
		_value = [SMJUtils numberWithString:string];
		
		if (!_value)
			_value = @0;
	}
	
	return self;
}

- (instancetype)initWithNumber:(NSNumber *)number
{
	self = [super init];
	
	if (self)
	{
		_value = number;
	}
	
	return self;
}

- (NSString *)stringValue
{
	return [_value stringValue];
}

- (nullable NSString *)literalValue
{
	return [self stringValue];
}

- (NSString *)typeName
{
	return @"number";
}

- (NSNumber *)underlayingObjectWithError:(NSError **)error
{
	return _value;
}

@end
*/
