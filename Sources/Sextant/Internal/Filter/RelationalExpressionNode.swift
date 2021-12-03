import Foundation
import Hitch

class RelationalExpressionNode: ExpressionNode {
    
}

/*
#import "SMJRelationalExpressionNode.h"

#import "SMJEvaluatorFactory.h"


NS_ASSUME_NONNULL_BEGIN



#pragma mark - SMJRelationalExpressionNode

@implementation SMJRelationalExpressionNode
{
	SMJValueNode *_left;
	SMJRelationalOperator *_relationalOperator;
	SMJValueNode *_right;
}



#pragma mark - SMJRelationalExpressionNode - Instance

+ (instancetype)relationExpressionNodeWithLeftValue:(SMJValueNode *)leftValue operator:(SMJRelationalOperator *)op rightValue:(SMJValueNode *)rightValue
{
	return [[[self class] alloc] initWithLeftValue:leftValue operator:op rightValue:rightValue];
}

- (instancetype)initWithLeftValue:(SMJValueNode *)leftValue operator:(SMJRelationalOperator *)op rightValue:(SMJValueNode *)rightValue
{
	self = [super init];
	
	if (self)
	{
		_left = leftValue;
		_right = rightValue;
		_relationalOperator = op;
	}
	
	return self;
}



#pragma mark - SMJRelationalExpressionNode - SMJPredicate

- (SMJPredicateApply)applyWithContext:(id <SMJPredicateContext>)context error:(NSError **)error
{
	SMJValueNode *left = _left;
	SMJValueNode *right = _right;
	
	if ([_left isKindOfClass:[SMJPathNode class]])
	{
		SMJPathNode *tmp = (SMJPathNode *)_left;
		
		// SourceMac-Note: we support the "EXISTS" token, event if it's similar (and so redoundant) to don't use operator and right value.
		if (_relationalOperator == [SMJRelationalOperator relationalOperatorEXISTS] && tmp.existsCheck == NO)
			tmp = [tmp copyWithExistsCheckAndShouldExists:tmp.shouldExists];
		
		left = [tmp evaluate:context error:error];
		
		if (!left)
			return SMJPredicateApplyError;
	}
	
	if ([_right isKindOfClass:[SMJPathNode class]])
	{
		SMJPathNode *tmp = (SMJPathNode *)_right;
		
		right = [tmp evaluate:context error:error];

		if (!right)
			return SMJPredicateApplyError;
	}
	
	id <SMJEvaluator> evaluator = [SMJEvaluatorFactory createEvaluatorForRelationalOperator:_relationalOperator error:error];

	if (!evaluator)
		return SMJPredicateApplyError;
	
	
	SMJEvaluatorEvaluate result = [evaluator evaluateLeftNode:left rightNode:right predicateContext:context error:error];
	
	if (result == SMJEvaluatorEvaluateTrue)
		return SMJPredicateApplyTrue;
	else if (result == SMJEvaluatorEvaluateFalse)
		return SMJPredicateApplyFalse;
	else if (result == SMJEvaluatorEvaluateError)
		return SMJPredicateApplyError;
	
	return SMJPredicateApplyFalse;
}

- (NSString *)stringValue
{
	if (_relationalOperator == [SMJRelationalOperator relationalOperatorEXISTS])
		return [_left stringValue];
	else
		return [NSString stringWithFormat:@"%@ %@ %@", [_left stringValue], _relationalOperator.stringOperator, [_right stringValue]];
}

@end


NS_ASSUME_NONNULL_END
*/
