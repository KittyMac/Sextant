import Foundation
import Hitch

final class ObjectPropertyPath: Path {
    let property: Hitch
    
    init(object: JsonAny,
         property: Hitch) {
        self.property = property
        super.init(parent: object)
    }
}
/*
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
 */
