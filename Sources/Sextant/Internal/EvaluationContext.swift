import Foundation
import Hitch

final class EvaluationContext {
    let forUpdate = false

    var updateOperations = [Path]()

    var valueResults = JsonArray()
    var pathResults = [String]()
    var resultIndex = 0

    var evaluationCache = [Hitch: JsonAny]()

    var path: Path
    var rootJsonObject: JsonAny

    init(path: Path,
         rootJsonObject: JsonAny) {

        self.path = path
        self.rootJsonObject = rootJsonObject
    }

    func add(path: Hitch,
             operation: Path,
             jsonObject: JsonAny) -> EvaluationStatus {
        if forUpdate {
            updateOperations.append(operation)
        }

        valueResults.append(jsonObject)
        pathResults.append(path.description)

        resultIndex += 1

        // TODO: listeners and continuations
        /*
         NSArray     *evaluationListeners = _configuration.evaluationListeners;
         NSInteger    idx = _resultIndex - 1;
         
         for (id <SMJEvaluationListener> listener in evaluationListeners)
         {
             SMJEvaluationContinuation continuation = [listener resultFound:[FoundResultImpl foundResultWithIndex:idx path:path result:jsonObject]];
             
             if (continuation == SMJEvaluationContinuationAbort)
                 return SMJEvaluationContextStatusAborted;
         }
         
         return SMJEvaluationContextStatusDone;
         */
        return .done
    }

    func jsonObject() -> JsonAny {
        if path.isDefinite() {
            if resultIndex == 0 || valueResults.count == 0 {
                error("No results for path: \(path)")
                return nil
            }

            return valueResults[valueResults.count - 1]
        }

        return valueResults
    }

    func resultsValues() -> JsonArray? {
        if path.isDefinite() {
            if resultIndex == 0 || valueResults.count == 0 {
                error("No results for path: \(path)")
                return nil
            }

            return [valueResults[valueResults.count - 1]]
        }

        return valueResults
    }

    func resultsPaths() -> JsonArray? {
        if path.isDefinite() {
            if resultIndex == 0 || valueResults.count == 0 {
                error("No results for path: \(path)")
                return nil
            }

            return [pathResults[pathResults.count - 1]]
        }

        return pathResults
    }
}

/*
#import "SMJEvaluationContextImpl.h"


NS_ASSUME_NONNULL_BEGIN


#pragma mark FoundResultImpl

@interface FoundResultImpl : NSObject <SMJFoundResult>

@end


@implementation FoundResultImpl

@synthesize index, path, result;

+ (instancetype)foundResultWithIndex:(NSInteger)index path:(NSString *)path result:(id)result
{
	FoundResultImpl *obj = [FoundResultImpl new];
	
	obj->index = index;
	obj->path = path;
	obj->result = result;

	return obj;
}

@end


#pragma mark - SMJEvaluationContextImpl

@implementation SMJEvaluationContextImpl
{
	SMJConfiguration *_configuration;
	NSMutableArray *_valueResult;
	NSMutableArray *_pathResult;
	id <SMJPath> _path;
	id _rootJsonObject;
	NSMutableArray <SMJPathRef *> *_updateOperations;
	NSInteger _resultIndex;
}


#pragma mark - SMJEvaluationContextImpl - Instance

- (instancetype)initWithPath:(id <SMJPath>)path rootJsonObject:(id)rootJsonObject configuration:(SMJConfiguration *)configuration forUpdate:(BOOL)forUpdate
{
	self = [super init];
	
	if (self)
	{
		//notNull(path, "path can not be null");
		//notNull(rootJsonObject, "root can not be null");
		//notNull(configuration, "configuration can not be null");
		
		_evaluationCache = [[NSMutableDictionary alloc] init];
		
		_forUpdate = forUpdate;
		_path = path;
		_rootJsonObject = rootJsonObject;
		_configuration = configuration;
		_valueResult = [NSMutableArray array];
		_pathResult = [NSMutableArray array];
		_updateOperations = [NSMutableArray array];
	}
	
	return self;
}



#pragma mark - SMJEvaluationContextImpl - Result

- (SMJEvaluationContextStatus)addResult:(NSString *)path operation:(SMJPathRef *)operation jsonObject:(id)jsonObject
{
	if (_forUpdate)
		[_updateOperations addObject:operation];
	
	[_valueResult addObject:jsonObject];
	[_pathResult addObject:[path copy]];
	
	_resultIndex++;
	
	NSArray 	*evaluationListeners = _configuration.evaluationListeners;
	NSInteger	idx = _resultIndex - 1;
	
	for (id <SMJEvaluationListener> listener in evaluationListeners)
	{
		SMJEvaluationContinuation continuation = [listener resultFound:[FoundResultImpl foundResultWithIndex:idx path:path result:jsonObject]];
		
		if (continuation == SMJEvaluationContinuationAbort)
			return SMJEvaluationContextStatusAborted;
	}
	
	return SMJEvaluationContextStatusDone;
}



#pragma mark - SMJEvaluationContextImpl - SMJEvaluationContext

- (SMJConfiguration *)configuration
{
	return _configuration;
}

- (NSArray <NSString *> *)pathList
{
	return [_pathResult copy];
}

- (NSArray <SMJPathRef *> *)updateOperations
{
	return [_updateOperations copy];
}

- (nullable id)jsonObjectWithError:(NSError **)error
{
	if (_path.definite)
	{
		if (_resultIndex == 0 || _valueResult.count == 0)
		{
			SMSetError(error, 1, @"No results for path: %@", [_path stringValue]);
			return nil;
		}
		
		return _valueResult.lastObject;
	}
	
	if (_valueResult == nil)
		return [NSNull null];
	
	return [_valueResult copy];
}

- (id)rootJsonObject
{
	return _rootJsonObject;
}

@end


NS_ASSUME_NONNULL_END
*/
