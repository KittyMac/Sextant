import Foundation
import Hitch

enum EvaluatorResult {
    case `true`
    case `false`
    case error
}

class Evaluator {
    
    init?(relationalOperator: RelationalOperator) {
        return nil
    }
    
    func evaluate(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
        fatalError("must be overridden")
    }
}


/*
#pragma mark - SMJEvaluatorGeneric

typedef SMJEvaluatorEvaluate (^SMJEvaluatorGenericBlock)(SMJValueNode *leftNode, SMJValueNode *rightNode, id <SMJPredicateContext> context, NSError **);

@interface SMJEvaluatorGeneric : NSObject <SMJEvaluator>

+ (instancetype)evaluatorWithBlock:(SMJEvaluatorGenericBlock)block;

@end


@implementation SMJEvaluatorGeneric
{
	SMJEvaluatorGenericBlock _block;
}

+ (instancetype)evaluatorWithBlock:(SMJEvaluatorGenericBlock)block
{
	SMJEvaluatorGeneric *result = [[SMJEvaluatorGeneric alloc] init];
	
	result->_block = block;
	
	return result;
}

- (SMJEvaluatorEvaluate)evaluateLeftNode:(SMJValueNode *)left rightNode:(SMJValueNode *)right predicateContext:(id <SMJPredicateContext>)context error:(NSError **)error
{
	return _block(left, right, context, error);
}

@end




#pragma mark - SMJEvaluatorFactory

@implementation SMJEvaluatorFactory

+ (nullable id <SMJEvaluator>)createEvaluatorForRelationalOperator:(SMJRelationalOperator *)relationalOperator error:(NSError **)error
{
	return [self createEvaluatorForRelationalOperatorString:relationalOperator.stringOperator error:error];
}

+ (nullable id <SMJEvaluator>)createEvaluatorForRelationalOperatorString:(NSString *)relationalOperator error:(NSError **)error
{
	static dispatch_once_t onceToken;
	static NSDictionary <NSString *, id <SMJEvaluator>> *map;
	
	dispatch_once(&onceToken, ^{
		map = [self buildEvaluatorsMap];
	});
	
	
	id <SMJEvaluator> evaluator = map[relationalOperator];
	
	if (!evaluator)
	{
		SMSetError(error, 1, @"can't found evaluator for operator %@", relationalOperator);
		return nil;
	}
	
	return evaluator;
}


+ (NSDictionary <NSString *, id <SMJEvaluator>> *)buildEvaluatorsMap
{
	NSMutableDictionary <NSString *, id <SMJEvaluator>> *map = [[NSMutableDictionary alloc] init];
	
	
	// Exists.
	map[SMJRelationalOperatorEXISTS] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		if (![leftNode isKindOfClass:[SMJBooleanNode class]] || ![rightNode isKindOfClass:[SMJBooleanNode class]])
		{
			SMSetError(error, 1, @"Failed to evaluate EXISTS expression");
			return SMJEvaluatorEvaluateError;
		}
		
		SMJEqualityResult equality = [leftNode isEqual:rightNode withError:error];
		
		if (equality == SMJEqualityError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(equality == SMJEqualitySame);
	}];
	
	
	// Not Equals.
	map[SMJRelationalOperatorNE] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJComparisonResult comparison = [leftNode compare:rightNode withError:error];
		
		if (comparison == SMJComparisonError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(comparison != SMJComparisonSame);
	}];
	
	
	// Type Safe Not Equals.
	map[SMJRelationalOperatorTSNE] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJEqualityResult equality = [leftNode isEqual:rightNode withError:error];

		if (equality == SMJEqualityError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(equality == SMJEqualityDiffer);
	}];
	
	
	// Equals.
	map[SMJRelationalOperatorEQ] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJComparisonResult comparison = [leftNode compare:rightNode withError:error];
		
		if (comparison == SMJComparisonError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(comparison == SMJComparisonSame);
	}];
	
	
	// Type Safe Equals.
	map[SMJRelationalOperatorTSEQ] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJEqualityResult equality = [leftNode isEqual:rightNode withError:error];

		if (equality == SMJEqualityError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(equality == SMJEqualitySame);
	}];
	
	
	// Less Than.
	map[SMJRelationalOperatorLT] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJComparisonResult comparison = [leftNode compare:rightNode withError:error];
		
		if (comparison == SMJComparisonError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(comparison == SMJComparisonDifferLessThan);
	}];
	
	
	// Less Than Equals.
	map[SMJRelationalOperatorLTE] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJComparisonResult comparison = [leftNode compare:rightNode withError:error];

		if (comparison == SMJComparisonError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(comparison == SMJComparisonSame || comparison == SMJComparisonDifferLessThan);
	}];
	
	
	// Greater Than.
	map[SMJRelationalOperatorGT] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJComparisonResult comparison = [leftNode compare:rightNode withError:error];

		if (comparison == SMJComparisonError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(comparison == SMJComparisonDifferGreaterThan);
	}];
	
	
	// Greater Than Equals.
	map[SMJRelationalOperatorGTE] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		SMJComparisonResult comparison = [leftNode compare:rightNode withError:error];

		if (comparison == SMJComparisonError)
			return SMJEvaluatorEvaluateError;
		
		return SMBoolToEvaluateResult(comparison == SMJComparisonSame || comparison == SMJComparisonDifferGreaterThan);
	}];
	
	
	// Regexp.
	map[SMJRelationalOperatorREGEX] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		NSRegularExpression	*regexp = nil;
		NSString			*string = nil;
		
		if ([leftNode isKindOfClass:[SMJPatternNode class]] && ![rightNode isKindOfClass:[SMJPatternNode class]])
		{
			regexp = [(SMJPatternNode *)leftNode underlayingObjectWithError:error];
			string = [rightNode literalValue];
		}
		else if (![leftNode isKindOfClass:[SMJPatternNode class]] && [rightNode isKindOfClass:[SMJPatternNode class]])
		{
			regexp = [(SMJPatternNode *)rightNode underlayingObjectWithError:error];
			string = [leftNode literalValue];
		}

		if (!regexp)
			return SMJEvaluatorEvaluateError;
		
		if (regexp && string)
			return SMBoolToEvaluateResult([regexp numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)] > 0);
		
		return SMJEvaluatorEvaluateFalse;
	}];
	
	
	// Size.
	map[SMJRelationalOperatorSIZE] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		if ([rightNode isKindOfClass:[SMJNumberNode class]] == NO)
			return SMJEvaluatorEvaluateFalse;

		NSNumber	*expectedSizeNumber = [(SMJNumberNode *)rightNode underlayingObjectWithError:nil];
		NSUInteger	expectedSize = [expectedSizeNumber unsignedIntegerValue];
		
		if ([leftNode isKindOfClass:[SMJStringNode class]])
		{
			NSString *string = [(SMJStringNode *)leftNode underlayingObjectWithError:nil];
			
			return SMBoolToEvaluateResult(string.length == expectedSize);
		}
		else if ([leftNode isKindOfClass:[SMJJsonNode class]])
		{
			id jsonObj = [(SMJJsonNode *)leftNode underlayingObjectWithError:error];
			
			if (!jsonObj)
				return SMJEvaluatorEvaluateError;
			
			if ([jsonObj isKindOfClass:[NSArray class]])
				return SMBoolToEvaluateResult([(NSArray *)jsonObj count] == expectedSize);
			else if ([jsonObj isKindOfClass:[NSDictionary class]])
				return SMBoolToEvaluateResult([(NSDictionary *)jsonObj count] == expectedSize);
		}
		
		return SMJEvaluatorEvaluateFalse;
	}];
	
	
	// Empty.
	map[SMJRelationalOperatorEMPTY] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		if ([rightNode isKindOfClass:[SMJBooleanNode class]] == NO)
			return SMJEvaluatorEvaluateFalse;

		NSNumber	*isEmptyNumber = [(SMJBooleanNode *)rightNode underlayingObjectWithError:error];
		BOOL		isEmpty = [isEmptyNumber boolValue];
		
		if (!isEmptyNumber)
			return SMJEvaluatorEvaluateError;
		
		if ([leftNode isKindOfClass:[SMJStringNode class]])
		{
			NSString *string = [(SMJStringNode *)leftNode underlayingObjectWithError:error];
			
			if (!string)
				return SMJEvaluatorEvaluateError;
			
			return SMBoolToEvaluateResult((string.length == 0) == isEmpty);
		}
		else if ([leftNode isKindOfClass:[SMJJsonNode class]])
		{
			id jsonObj = [(SMJJsonNode *)leftNode underlayingObjectWithError:error];
			
			if (!jsonObj)
				return SMJEvaluatorEvaluateError;
			
			if ([jsonObj isKindOfClass:[NSArray class]])
				return SMBoolToEvaluateResult(([(NSArray *)jsonObj count] == 0) == isEmpty);
			else if ([jsonObj isKindOfClass:[NSDictionary class]])
				return SMBoolToEvaluateResult(([(NSDictionary *)jsonObj count] == 0) == isEmpty);
		}
		
		return SMJEvaluatorEvaluateFalse;
	}];
	
	
	// In.
	map[SMJRelationalOperatorIN] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		// > Right.
		if ([rightNode isKindOfClass:[SMJJsonNode class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		id rightObject = [rightNode underlayingObjectWithError:error];
		
		if (!rightObject)
			return SMJEvaluatorEvaluateError;
		
		if (![rightObject isKindOfClass:[NSArray class]])
			return SMJEvaluatorEvaluateFalse;
		
		NSArray *rightArray = rightObject;
		
		// > Left.
		id leftObject = [leftNode underlayingObjectWithError:error];
		
		if (!leftObject)
			return SMJEvaluatorEvaluateError;
		
		// > Compare.
		return SMBoolToEvaluateResult([rightArray containsObject:leftObject]);
	}];
	
	
	
	// Not In.
	map[SMJRelationalOperatorNIN] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		id <SMJEvaluator> inEvaluator = [self createEvaluatorForRelationalOperatorString:SMJRelationalOperatorIN error:error];
		
		if (!inEvaluator)
			return SMJEvaluatorEvaluateError;
		
		SMJEvaluatorEvaluate result = [inEvaluator evaluateLeftNode:leftNode rightNode:rightNode predicateContext:context error:error];
		
		if (result == SMJEvaluatorEvaluateTrue)
			return SMJEvaluatorEvaluateFalse;
		else if (result == SMJEvaluatorEvaluateFalse)
			return SMJEvaluatorEvaluateTrue;
		else if (result == SMJEvaluatorEvaluateError)
			return SMJEvaluatorEvaluateError;
		
		return SMJEvaluatorEvaluateFalse;
	}];
	
	
	// All.
	map[SMJRelationalOperatorALL] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		if ([leftNode isKindOfClass:[SMJJsonNode class]] == NO || [rightNode isKindOfClass:[SMJJsonNode class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		// > Fetch right array.
		NSArray *rightArray = [(SMJJsonNode *)rightNode underlayingObjectWithError:error];
		
		if (!rightArray)
			return SMJEvaluatorEvaluateError;
		
		if ([rightArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		
		// > Fetch left array.
		NSArray *leftArray = [(SMJJsonNode *)leftNode underlayingObjectWithError:error];
		
		if (!leftArray)
			return SMJEvaluatorEvaluateError;
		
		if ([leftArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		// > All.
		for (id rightObject in rightArray)
		{
			if ([leftArray containsObject:rightObject] == NO)
				return SMJEvaluatorEvaluateFalse;
		}
		
		return SMJEvaluatorEvaluateTrue;
	}];

	
	// Contains.
	map[SMJRelationalOperatorCONTAINS] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		if ([leftNode isKindOfClass:[SMJStringNode class]] && [rightNode isKindOfClass:[SMJStringNode class]])
		{
			NSString *leftString = [(SMJStringNode *)leftNode underlayingObjectWithError:error];
			NSString *rightString = [(SMJStringNode *)rightNode underlayingObjectWithError:error];
			
			if (!leftString || !rightString)
				return SMJEvaluatorEvaluateError;

			NSRange range = [leftString rangeOfString:rightString];
			
			return SMBoolToEvaluateResult(range.location != NSNotFound);
		}
		else if ([leftNode isKindOfClass:[SMJJsonNode class]])
		{
			NSArray *leftArray = [(SMJJsonNode *)leftNode underlayingObjectWithError:error];
			
			if (!leftArray)
				return SMJEvaluatorEvaluateError;
			
			if ([leftArray isKindOfClass:[NSArray class]] == NO)
				return SMJEvaluatorEvaluateFalse;

			id rightValue = [rightNode underlayingObjectWithError:error];
			
			if (!rightValue)
				return SMJEvaluatorEvaluateError;


			return SMBoolToEvaluateResult([leftArray containsObject:rightValue]);
		}
		
		return SMJEvaluatorEvaluateFalse;
	}];
	

	// Type.
	map[SMJRelationalOperatorTYPE] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		BOOL isSameType = NO;
		
		// Check that left and right are the same type.
		if (!isSameType)
		{
			id leftObject = [leftNode underlayingObjectWithError:error];
			id rightObject = [rightNode underlayingObjectWithError:error];

			if (!leftObject || !rightObject)
				return SMJEvaluatorEvaluateError;
			
			isSameType = ([rightObject isKindOfClass:leftObject] || [leftObject isKindOfClass:rightObject]);
		}
		
		// Check that left type name is equal to right string name.
		if (!isSameType)
		{
			if ([rightNode isKindOfClass:[SMJStringNode class]])
			{
				NSString *typeName = [(SMJStringNode *)rightNode underlayingObjectWithError:error];
				
				if (!typeName)
					return SMJEvaluatorEvaluateError;

				if ([[leftNode typeName] isEqualToString:typeName])
					isSameType = YES;
			}
		}
		
		return SMBoolToEvaluateResult(isSameType);
	}];
	
	
	// Subset Of.
	map[SMJRelationalOperatorSUBSETOF] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {
		
		if ([leftNode isKindOfClass:[SMJJsonNode class]] == NO || [rightNode isKindOfClass:[SMJJsonNode class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		// > Fetch right array.
		NSArray *rightArray = [(SMJJsonNode *)rightNode underlayingObjectWithError:error];
		
		if (!rightArray)
			return SMJEvaluatorEvaluateError;
		
		if ([rightArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		
		// > Fetch left array.
		NSArray *leftArray = [(SMJJsonNode *)leftNode underlayingObjectWithError:error];
		
		if (!leftArray)
			return SMJEvaluatorEvaluateError;
		
		if ([leftArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		
		// > Check subset-of.
		for (id leftObject in leftArray)
		{
			if ([rightArray containsObject:leftObject] == NO)
				return SMJEvaluatorEvaluateFalse;
		}
		
		return SMJEvaluatorEvaluateTrue;
	}];
	
	
	// Any of.
	map[SMJRelationalOperatorANYOF] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {

		if ([leftNode isKindOfClass:[SMJJsonNode class]] == NO || [rightNode isKindOfClass:[SMJJsonNode class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		// > Fetch right array.
		NSArray *rightArray = [(SMJJsonNode *)rightNode underlayingObjectWithError:error];
		
		if (!rightArray)
			return SMJEvaluatorEvaluateError;
		
		if ([rightArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		
		// > Fetch left array.
		NSArray *leftArray = [(SMJJsonNode *)leftNode underlayingObjectWithError:error];
		
		if (!leftArray)
			return SMJEvaluatorEvaluateError;
		
		if ([leftArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;

		
		// > Check any-of.
		for (id leftObject in leftArray)
		{
			if ([rightArray containsObject:leftObject])
				return SMJEvaluatorEvaluateTrue;
		}
		
		return SMJEvaluatorEvaluateFalse;
	}];
	
	// None of.
	map[SMJRelationalOperatorNONEOF] = [SMJEvaluatorGeneric evaluatorWithBlock:^SMJEvaluatorEvaluate(SMJValueNode *leftNode, SMJValueNode *rightNode, id<SMJPredicateContext> context, NSError **error) {

		if ([leftNode isKindOfClass:[SMJJsonNode class]] == NO || [rightNode isKindOfClass:[SMJJsonNode class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		// > Fetch right array.
		NSArray *rightArray = [(SMJJsonNode *)rightNode underlayingObjectWithError:error];
		
		if (!rightArray)
			return SMJEvaluatorEvaluateError;
		
		if ([rightArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		
		// > Fetch left array.
		NSArray *leftArray = [(SMJJsonNode *)leftNode underlayingObjectWithError:error];
		
		if (!leftArray)
			return SMJEvaluatorEvaluateError;
		
		if ([leftArray isKindOfClass:[NSArray class]] == NO)
			return SMJEvaluatorEvaluateFalse;
		
		
		// > Check none-of.
		for (id leftObject in leftArray)
		{
			if ([rightArray containsObject:leftObject])
				return SMJEvaluatorEvaluateFalse;
		}
		
		return SMJEvaluatorEvaluateTrue;
	}];
	
	return map;
}

@end


NS_ASSUME_NONNULL_END
*/
