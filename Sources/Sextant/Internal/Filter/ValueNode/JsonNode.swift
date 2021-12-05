import Foundation
import Hitch

class JsonNode: ValueNode {
    
}


/*
@implementation SMJJsonNode
{
    NSString *_jsonString;
    
    BOOL    _done;
    id        _json;
    NSError    *_error;
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    
    if (self)
    {
        _jsonString = [string copy];
    }
    
    return self;
}

- (instancetype)initWithJsonObject:(id)jsonObject
{
    self = [super init];
    
    if (self)
    {
        _json = jsonObject;
        _done = YES;
    }
    
    return self;
}

- (NSString *)stringValue
{
    if (!_jsonString)
    {
        NSError    *lerror = nil;
        NSData    *jsonData = [NSJSONSerialization dataWithJSONObject:_json options:NSJSONWritingPrettyPrinted error:&lerror];
        
        if (jsonData)
            _jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if (!_jsonString)
        return @"null";
    
    return _jsonString;
}

- (NSString *)typeName
{
    return @"json";
}

- (nullable id)underlayingObjectWithError:(NSError **)error
{
    if (!_done)
    {
        NSError *lerror = nil;
        
        _json = [NSJSONSerialization JSONObjectWithData:[_jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&lerror];
        _error = lerror;
        _done = YES;
                
        if (_json && [_json isKindOfClass:[NSDictionary class]] == NO && [_json isKindOfClass:[NSArray class]] == NO)
        {
            _json = nil;
            _error = [NSError errorWithDomain:@"SMJValueNodesErrorNode" code:1 userInfo:@{ NSLocalizedDescriptionKey : @"Invalid JSON type" }];
        }
    }
    
    if (error)
        *error = _error;
        
    return _json;
}
*/
