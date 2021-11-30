import Foundation
import Hitch

final class RootPath: Path {
    
    init(rootObject: JsonAny) {
        super.init(parent: rootObject)
    }
}
/*
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
 */
