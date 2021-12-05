import Foundation
import Hitch

class PathNode: ValueNode {
    let pathString: Hitch
    let path: Path
    
    let existsCheck: Bool
    let shouldExists: Bool
    
    init(path pathString: Hitch,
         prebuiltPath: Path,
         existsCheck: Bool,
         shouldExists: Bool) {
        self.pathString = pathString
        self.path = prebuiltPath
        self.existsCheck = existsCheck
        self.shouldExists = shouldExists
    }
    
    override func evaluate(context: PredicateContext) -> ValueNode? {
        
        if existsCheck {
            
            guard let evaluationContext = path.evaluate(jsonObject: context.jsonObject,
                                                        rootJsonObject: context.rootJsonObject) else {
                return BooleanNode(value: false)
            }
            
            if let value = evaluationContext.jsonObject() {
                return BooleanNode(value: true)
            }
            return BooleanNode(value: false)
        } else {
                        
            let doc = path.isRootPath() ? context.rootJsonObject : context.jsonObject
            guard let evaluationContext = path.evaluate(jsonObject: doc,
                                                        rootJsonObject: context.rootJsonObject) else {
                return nil
            }
            
            let object = evaluationContext.jsonObject()
            
            if let object = object as? String {
                return StringNode(hitch: object.hitch(), escape: false)
            }
            if let object = object as? Hitch {
                return StringNode(hitch: object, escape: false)
            }
            

        }
        
        return nil
        /*
            id object = nil;
            
            if ([context isKindOfClass:[SMJPredicateContextImpl class]])
            {
                //This will use cache for root ($) queries
                SMJPredicateContextImpl *ctxi = (SMJPredicateContextImpl *)context;
                
                object = [ctxi evaluatePath:_path error:error];
            }
            else
            {
                id doc = _path.rootPath ? context.rootJsonObject : context.jsonObject;
                id <SMJEvaluationContext> evaluationContext = [_path evaluateJsonObject:doc rootJsonObject:context.rootJsonObject configuration:context.configuration error:error];
                
                object = [evaluationContext jsonObjectWithError: error];
            }
            
            if (!object)
                return nil;
            
            if ([object isKindOfClass:[NSNumber class]])
            {
                NSNumber *number = object;
                
                if (strcmp([number objCType], @encode(BOOL)) == 0)
                    return [[SMJBooleanNode alloc] initWithBoolean:[number boolValue]];
                else
                    return [[SMJNumberNode alloc] initWithNumber:number];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                return [[SMJStringNode alloc] initWithString:object];
            }
            else if ([object isKindOfClass:[NSNull class]])
            {
                return [[SMJNullNode alloc] initInternal];
            }
            else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]])
            {
                return [[SMJJsonNode alloc] initWithJsonObject:object];
            }
            else
            {
                SMSetError(error, 1, @"Could not convert %@ to a ValueNode", [object class]);
                return nil;
            }
        }
        
        return nil;
         */
    }
    
}


/*
@implementation SMJPathNode
{
	NSString		*_pathString;
	id <SMJPath>	_path;
	
	BOOL _existsCheck;
	BOOL _shouldExists;
}

- (nullable instancetype)initWithPathString:(NSString *)pathString existsCheck:(BOOL)existsCheck shouldExists:(BOOL)shouldExists error:(NSError **)error
{
	self = [super init];
	
	if (self)
	{
		_path = [SMJPathCompiler compilePathString:pathString error:error];
		
		if (!_path)
			return nil;
		
		_pathString = [pathString copy];
		_existsCheck = existsCheck;
		_shouldExists = shouldExists;
	}
	
	return self;
}

- (instancetype)initWithPath:(id <SMJPath>)path
{
	self = [super init];
	
	if (self)
	{
		_path = path;
		_pathString = [path stringValue];
	}
	
	return self;
}

- (instancetype)initWithPathString:(NSString *)pathString prebuiltPath:(id <SMJPath>)path existsCheck:(BOOL)existsCheck shouldExists:(BOOL)shouldExists
{
	self = [super init];
	
	if (self)
	{
		_pathString = [pathString copy];
		_path = path;
		_existsCheck = existsCheck;
		_shouldExists = shouldExists;
	}
	
	return self;
}

- (instancetype)copyWithExistsCheckAndShouldExists:(BOOL)shouldExists
{
	return [[SMJPathNode alloc] initWithPathString:_pathString prebuiltPath:_path existsCheck:YES shouldExists:shouldExists];
}

- (BOOL)shouldExists
{
	return _shouldExists;
}

- (BOOL)isExistsCheck
{
	return _existsCheck;
}

- (nullable SMJPathNode *)pathNodeWithError:(NSError **)error
{
	return self;
}

- (nullable SMJValueNode *)evaluate:(id <SMJPredicateContext>)context error:(NSError **)error
{
	if (self.existsCheck)
	{
		SMJConfiguration *configuration = [context.configuration copy];
		
		[configuration addOption:SMJOptionRequireProperties];
		
		id <SMJEvaluationContext> evaluationContext = [_path evaluateJsonObject:context.jsonObject rootJsonObject:context.rootJsonObject configuration:configuration error:nil];
		
		if (!evaluationContext)
			return [SMJValueNodes valueNodeFALSE];
		
		id value = [evaluationContext jsonObjectWithError:nil];
		
		if (value)
			return [SMJValueNodes valueNodeTRUE];
		else
			return [SMJValueNodes valueNodeFALSE];
	}
	else
	{
		id object = nil;
		
		if ([context isKindOfClass:[SMJPredicateContextImpl class]])
		{
			//This will use cache for root ($) queries
			SMJPredicateContextImpl *ctxi = (SMJPredicateContextImpl *)context;
			
			object = [ctxi evaluatePath:_path error:error];
		}
		else
		{
			id doc = _path.rootPath ? context.rootJsonObject : context.jsonObject;
			id <SMJEvaluationContext> evaluationContext = [_path evaluateJsonObject:doc rootJsonObject:context.rootJsonObject configuration:context.configuration error:error];
			
			object = [evaluationContext jsonObjectWithError: error];
		}
		
		if (!object)
			return nil;
		
		if ([object isKindOfClass:[NSNumber class]])
		{
			NSNumber *number = object;
			
			if (strcmp([number objCType], @encode(BOOL)) == 0)
				return [[SMJBooleanNode alloc] initWithBoolean:[number boolValue]];
			else
				return [[SMJNumberNode alloc] initWithNumber:number];
		}
		else if ([object isKindOfClass:[NSString class]])
		{
			return [[SMJStringNode alloc] initWithString:object];
		}
		else if ([object isKindOfClass:[NSNull class]])
		{
			return [[SMJNullNode alloc] initInternal];
		}
		else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]])
		{
			return [[SMJJsonNode alloc] initWithJsonObject:object];
		}
		else
		{
			SMSetError(error, 1, @"Could not convert %@ to a ValueNode", [object class]);
			return nil;
		}
	}
	
	return nil;
}

- (NSString *)stringValue
{
	if (_existsCheck && !_shouldExists)
		return [SMJUtils stringByConcatenatingStrings:@[ @"!", [_path stringValue] ]];
	else
		return [_path stringValue];
}

- (NSString *)typeName
{
	return @"path";
}

- (id <SMJPath>)underlayingObjectWithError:(NSError **)error
{
	return _path;
}

- (nullable id)comparableUnderlayingObjectWithError:(NSError **)error
{
	return _pathString;
}
*/
