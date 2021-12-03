import Foundation
import Hitch

class LogicalExpressionNode: ExpressionNode {
    var op: LogicalOperator
    var chain: [ExpressionNode]
    
    init(op: LogicalOperator, nodes: [ExpressionNode]) {
        self.op = op
        self.chain = nodes
    }
    
    override func apply(predicateContext: PredicateContext) -> PredicateApply {
        fatalError("TO BE IMPLEMENTED")
    }
    
    override var description: String {
        fatalError("TO BE IMPLEMENTED")
    }
    
    
    
    class func logicalNot(node: ExpressionNode) -> LogicalExpressionNode {
        return LogicalExpressionNode(op: LogicalOperator.logicalOperatorNOT(), nodes: [node])
    }

    class func logicalOr(leftNode: ExpressionNode, rightNode: ExpressionNode) -> LogicalExpressionNode {
        return LogicalExpressionNode(op: LogicalOperator.logicalOperatorOR(), nodes: [leftNode, rightNode])

    }

    class func logicalOr(nodes: [ExpressionNode]) -> LogicalExpressionNode {
        return LogicalExpressionNode(op: LogicalOperator.logicalOperatorOR(), nodes: nodes)

    }

    class func logicalAnd(leftNode: ExpressionNode, rightNode: ExpressionNode) -> LogicalExpressionNode {
        return LogicalExpressionNode(op: LogicalOperator.logicalOperatorAND(), nodes: [leftNode, rightNode])

    }

    class func logicalAnd(nodes: [ExpressionNode]) -> LogicalExpressionNode {
        return LogicalExpressionNode(op: LogicalOperator.logicalOperatorAND(), nodes: nodes)
    }
}


/*
#pragma mark - SMJLogicalExpressionNode - Instance




#pragma mark - SMJLogicalExpressionNode - SMJPredicate

- (SMJPredicateApply)applyWithContext:(id <SMJPredicateContext>)context error:(NSError **)error
{
	if (_operator == [SMJLogicalOperator logicalOperatorOR])
	{
		for (SMJExpressionNode *expression in _chain)
		{
			SMJPredicateApply result = [expression applyWithContext:context error:error];
			
			if (result == SMJPredicateApplyError)
				return SMJPredicateApplyError;
			else if (result == SMJPredicateApplyTrue)
				return SMJPredicateApplyTrue;
		}
		
		return SMJPredicateApplyFalse;
	}
	else if (_operator == [SMJLogicalOperator logicalOperatorAND])
	{
		for (SMJExpressionNode *expression in _chain)
		{
			SMJPredicateApply result = [expression applyWithContext:context error:error];

			if (result == SMJPredicateApplyError)
				return SMJPredicateApplyError;
			else if (result == SMJPredicateApplyFalse)
				return SMJPredicateApplyFalse;
		}
		
		return SMJPredicateApplyTrue;
	}
	else
	{
		SMJExpressionNode *expression = _chain[0];
		SMJPredicateApply result = [expression applyWithContext:context error:error];

		if (result == SMJPredicateApplyError)
			return SMJPredicateApplyError;
		
		if (result == SMJPredicateApplyFalse)
			return SMJPredicateApplyTrue;
		else
			return SMJPredicateApplyFalse;
	}
}

- (NSString *)stringValue
{
	NSMutableString		*result = [[NSMutableString alloc] init];
	NSString			*delimiter = [NSString stringWithFormat:@" %@ ", _operator.stringOperator];
	
	[result appendString:@"("];
	
	[_chain enumerateObjectsUsingBlock:^(SMJExpressionNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		if (idx > 0)
			[result appendString:delimiter];
		
		[result appendString:[obj stringValue]];
	}];
	
	[result appendString:@")"];

	return result;
}

@end


NS_ASSUME_NONNULL_END
*/
