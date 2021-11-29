import Foundation
import Hitch

public class Path {
    class func newPath(object: JsonAny, item: JsonAny) -> Path {
        return ArrayIndexPath(object: object, item: item)
    }
    class func nullPath() -> Path {
        return NullPath.shared
    }
    
    var parent: JsonAny
    
    init(parent: JsonAny) {
        self.parent = parent
    }
    
    public var description: String {
        return ""
    }
    
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext? {
        fatalError("TO BE IMPLEMENTED")
        //return nil
    }
    
    func isDefinite() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        //return false
    }
    
    func isFunctionPath() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        //return false
    }
    
    func isRootPath() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        //return false
    }
}

/*
 
#pragma mark - Subpaths - Interface

@interface SMJNullPathRef : SMJPathRef
@end

@interface SMJRootPathRef : SMJPathRef
- (instancetype)initWithRootObject:(id)root;
@end

@interface SMJObjectPropertyPathRef : SMJPathRef
- (instancetype)initWithObject:(id)object property:(NSString *)property;
@end

@interface SMJObjectMultiPropertyPathRef : SMJPathRef
- (instancetype)initWithObject:(id)object properties:(NSArray <NSString *> *)properties;
@end

@interface SMJArrayIndexPathRef : SMJPathRef
- (instancetype)initWithObject:(id)object item:(id)item;
@end



#pragma mark - SMJPathRef - Private

@interface SMJPathRef ()

@property (readonly) id parent;

@end


#pragma mark - SMJPathRef

@implementation SMJPathRef


#pragma mark - SMJPathRef - Instance

+ (instancetype)pathRefNull
{
	static dispatch_once_t	onceToken;
	static SMJNullPathRef	*shr = nil;
	
	dispatch_once(&onceToken, ^{
		shr = [[SMJNullPathRef alloc] init];
	});
	
	return shr;
}

+ (instancetype)pathRefWithRootObject:(id)root;
{
	return [[SMJRootPathRef alloc] initWithRootObject:root];
}

+ (instancetype)pathRefWithObject:(id)object property:(NSString *)property
{
	return [[SMJObjectPropertyPathRef alloc] initWithObject:object property:property];
}

+ (instancetype)pathRefWithObject:(id)object properties:(NSArray <NSString *> *)properties
{
	return [[SMJObjectMultiPropertyPathRef alloc] initWithObject:object properties:properties];
}

+ (instancetype)pathRefWithObject:(id)object item:(id)item
{
	return [[SMJArrayIndexPathRef alloc] initWithObject:object item:item];
}

- (instancetype)initWithParent:(id)parent
{
	self = [super init];
	
	if (self)
	{
		_parent = parent;
	}
	
	return self;
}



#pragma mark - SMJPathRef - Operations

- (BOOL)setObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	// Must be overwritten.
	NSAssert(NO, @"must be overwrittent");
	return NO;
}

- (BOOL)convertWithMapper:(SMJPathRefMapper)mapper configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	// Must be overwritten.
	NSAssert(NO, @"must be overwrittent");
	return NO;
}

- (BOOL)deleteWithConfiguration:(SMJConfiguration *)configuration error:(NSError **)error
{
	// Must be overwritten.
	NSAssert(NO, @"must be overwrittent");
	return NO;
}

- (BOOL)addObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	// Must be overwritten.
	NSAssert(NO, @"must be overwrittent");
	return NO;
}

- (BOOL)putObject:(id)value forKey:(NSString *)key configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	// Must be overwritten.
	NSAssert(NO, @"must be overwrittent");
	return NO;
}

- (BOOL)renameKey:(NSString *)oldKey toKey:(NSString *)newKey configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	// Must be overwritten.
	NSAssert(NO, @"must be overwrittent");
	return NO;
}



#pragma mark - SMJPathRef - Tools

- (BOOL)renameInMap:(id)targetMap fromKey:(NSString *)oldKey toKey:(NSString *)newKey configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *targetDictionary = targetMap;
	
	if ([targetDictionary isKindOfClass:[NSMutableDictionary class]] == NO)
	{
		if ([targetDictionary isKindOfClass:[NSDictionary class]])
			SMSetError(error, 1, @"Can only rename properties in a mutable dictionary");
		else
			SMSetError(error, 2, @"Can only rename properties in a map");
		
		return NO;
	}
	
	id oldValue = [targetDictionary objectForKey:oldKey];
	
	if (oldValue == nil)
	{
		SMSetError(error, 3, @"No results for key %@ found in map", oldKey);
		return NO;
	}


	[targetDictionary removeObjectForKey:oldKey];
	[targetDictionary setObject:oldValue forKey:newKey];
	
	return YES;
}

- (nullable NSMutableDictionary *)dictionaryWithParentWithError:(NSError **)error
{
	return [self dictionaryWithObject:_parent error:error];
}

- (nullable NSMutableDictionary *)dictionaryWithObject:(id)object error:(NSError **)error
{
	NSMutableDictionary *dictionary = object;
	
	if ([dictionary isKindOfClass:[NSMutableDictionary class]])
	{
		return dictionary;
	}
	else
	{
		if ([dictionary isKindOfClass:[NSDictionary class]])
			SMSetError(error, 1, @"Invalid operation: dictionary should be mutable.");
		else
			SMSetError(error, 2, @"Invalid operation: node is not a map.");
		
		return nil;
	}
}

- (nullable NSMutableArray *)arrayWithParentWithError:(NSError **)error
{
	return [self arrayWithObject:_parent error:error];
}

- (nullable NSMutableArray *)arrayWithObject:(id)object error:(NSError **)error
{
	NSMutableArray *array = object;
	
	if ([array isKindOfClass:[NSMutableArray class]])
	{
		return array;
	}
	else
	{
		if ([array isKindOfClass:[NSArray class]])
			SMSetError(error, 1, @"Invalid operation: array should be mutable.");
		else
			SMSetError(error, 2, @"Invalid operation: node is not an array.");
		
		return nil;
	}
}

@end




#pragma mark - Subpaths


#pragma mark SMJNullPathRef

@implementation SMJNullPathRef

- (BOOL)setObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	return YES;
}

- (BOOL)convertWithMapper:(SMJPathRefMapper)mapper configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	return YES;
}

- (BOOL)deleteWithConfiguration:(SMJConfiguration *)configuration error:(NSError **)error
{
	return YES;
}

- (BOOL)addObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	return YES;
}

- (BOOL)putObject:(id)value forKey:(NSString *)key configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	return YES;
}

- (BOOL)renameKey:(NSString *)oldKey toKey:(NSString *)newKey configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	return YES;
}

@end


#pragma mark SMJRootPathRef

@implementation SMJRootPathRef

- (instancetype)initWithRootObject:(id)root
{
	self = [super initWithParent:root];
	
	if (self)
	{
	}
	
	return self;
}



- (BOOL)setObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	SMSetError(error, 1, @"Invalid set operation");
	return NO;
}

- (BOOL)convertWithMapper:(SMJPathRefMapper)mapper configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	SMSetError(error, 1, @"Invalid map operation");
	return NO;
}

- (BOOL)deleteWithConfiguration:(SMJConfiguration *)configuration error:(NSError **)error
{
	SMSetError(error, 1, @"Invalid delete operation");
	return NO;
}

- (BOOL)addObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableArray *parent = [self arrayWithParentWithError:error];
	
	if (!parent)
		return NO;

	[parent addObject:newVal];
	
	return YES;
}

- (BOOL)putObject:(id)value forKey:(NSString *)key configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	

	[parent setObject:value forKey:key];
	
	return YES;
}

- (BOOL)renameKey:(NSString *)oldKey toKey:(NSString *)newKey configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	id parent = self.parent;
	
	if (!parent)
		return YES;
	
	return [self renameInMap:parent fromKey:oldKey toKey:newKey configuration:configuration error:error];
}

@end


#pragma mark SMJObjectPropertyPathRef

@implementation SMJObjectPropertyPathRef
{
	NSString *_property;
}

- (instancetype)initWithObject:(id)object property:(NSString *)property
{
	self = [super initWithParent:object];
	
	if (self)
	{
		_property = property;
	}
	
	return self;
}

- (BOOL)setObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];

	if (!parent)
		return NO;
	
	[parent setObject:newVal forKey:_property];
	
	return YES;
}

- (BOOL)convertWithMapper:(SMJPathRefMapper)mapper configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	id currentValue = parent[_property];
	id newValue = mapper(currentValue, configuration);
	
	[parent setObject:newValue forKey:_property];
	
	return YES;
}

- (BOOL)deleteWithConfiguration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	[parent removeObjectForKey:_property];
	 
	return YES;
}

- (BOOL)addObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSMutableArray *target = [self arrayWithObject:[parent objectForKey:_property] error:error];
	
	if (!target)
		return NO;
	
	[target addObject:newVal];
	
	return YES;
}

- (BOOL)putObject:(id)value forKey:(NSString *)key configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSMutableDictionary *target = [self dictionaryWithObject:[parent objectForKey:_property] error:error];
	
	if (!target)
		return NO;
	
	[target setObject:value forKey:key];
	
	return YES;
}

- (BOOL)renameKey:(NSString *)oldKey toKey:(NSString *)newKey configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	id target = [parent objectForKey:_property];
	
	return [self renameInMap:target fromKey:oldKey toKey:newKey configuration:configuration error:error];
}


@end


#pragma mark SMJObjectMultiPropertyPathRef

@implementation SMJObjectMultiPropertyPathRef
{
	NSArray <NSString *> *_properties;
}

- (instancetype)initWithObject:(id)object properties:(NSArray <NSString *> *)properties
{
	self = [super initWithParent:object];
	
	if (self)
	{
		_properties = [properties copy];
	}
	
	return self;
}

- (BOOL)setObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	for (NSString *property in _properties)
		[parent setObject:newVal forKey:property];
	
	return YES;
}

- (BOOL)convertWithMapper:(SMJPathRefMapper)mapper configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	for (NSString *property in _properties)
	{
		id currentValue = parent[property];
		id newValue = mapper(currentValue, configuration);
		
		if (currentValue != nil)
			[parent setObject:newValue forKey:property];
	}
	
	return YES;
}

- (BOOL)deleteWithConfiguration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableDictionary *parent = [self dictionaryWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	for (NSString *property in _properties)
		[parent removeObjectForKey:property];
	
	return YES;
}

- (BOOL)addObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	SMSetError(error, 1, @"Add can not be performed to multiple properties");
	return NO;
}

- (BOOL)putObject:(id)value forKey:(NSString *)key configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	SMSetError(error, 1, @"Put can not be performed to multiple properties");
	return NO;
}

- (BOOL)renameKey:(NSString *)oldKey toKey:(NSString *)newKey configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	SMSetError(error, 1, @"Rename can not be performed to multiple properties");
	return NO;
}

@end


#pragma mark SMJArrayIndexPathRef

@implementation SMJArrayIndexPathRef
{
	id _item;
}

- (instancetype)initWithObject:(id)object item:(id)item
{
	self = [super initWithParent:object];
	
	if (self)
	{
		_item = item;
	}
	
	return self;
}

- (BOOL)setObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableArray *parent = [self arrayWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSInteger index = [parent indexOfObjectIdenticalTo:_item];
	
	if (index == NSNotFound)
		return NO;
	
	[parent replaceObjectAtIndex:index withObject:newVal];
	
	return YES;
}

- (BOOL)convertWithMapper:(SMJPathRefMapper)mapper configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableArray *parent = [self arrayWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSInteger index = [parent indexOfObjectIdenticalTo:_item];
	
	if (index == NSNotFound)
		return NO;

	id currentValue = [parent objectAtIndex:index];
	id newValue = mapper(currentValue, configuration);

	[parent replaceObjectAtIndex:index withObject:newValue];
	
	_item = newValue;
	
	return YES;
}

- (BOOL)deleteWithConfiguration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableArray *parent = [self arrayWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSInteger index = [parent indexOfObjectIdenticalTo:_item];

	if (index == NSNotFound)
		return NO;
	
	[parent removeObjectAtIndex:index];
	
	_item = nil;
	
	return YES;
}

- (BOOL)addObject:(id)newVal configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableArray *parent = [self arrayWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSInteger index = [parent indexOfObjectIdenticalTo:_item];
	
	if (index == NSNotFound)
		return NO;
	
	NSMutableArray *target =  [self arrayWithObject:[parent objectAtIndex:index] error:error];
	
	if (!target)
		return NO;
	
	[target addObject:newVal];
	
	return YES;
}

- (BOOL)putObject:(id)value forKey:(NSString *)key configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableArray *parent = [self arrayWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSInteger index = [parent indexOfObjectIdenticalTo:_item];

	if (index == NSNotFound)
		return NO;
	
	NSMutableDictionary *target = [self dictionaryWithObject:[parent objectAtIndex:index] error:error];
	
	if (!target)
		return NO;
	
	[target setObject:value forKey:key];
	
	return YES;
}

- (BOOL)renameKey:(NSString *)oldKey toKey:(NSString *)newKey configuration:(SMJConfiguration *)configuration error:(NSError **)error
{
	NSMutableArray *parent = [self arrayWithParentWithError:error];
	
	if (!parent)
		return NO;
	
	NSInteger index = [parent indexOfObjectIdenticalTo:_item];
	
	if (index == NSNotFound)
		return NO;
	
	id target = [parent objectAtIndex:index];
	
	return [self renameInMap:target fromKey:oldKey toKey:newKey configuration:configuration error:error];
}

@end


NS_ASSUME_NONNULL_END

 */
