import Foundation
import Hitch

final class ObjectMultiPropertyPath: Path {
    let properties: [Hitch]
    
    init(object: JsonAny,
         properties: [Hitch]) {
        self.properties = properties
        super.init(parent: object)
    }
}
/*
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
 */
