import Foundation
import Hitch

class RelationalExpressionNode: ExpressionNode {
    let left: ValueNode
    let relationalOperator: RelationalOperator
    let right: ValueNode
    
    init(left: ValueNode,
         relationalOperator: RelationalOperator,
         right: ValueNode) {
        self.left = left
        self.relationalOperator = relationalOperator
        self.right = right
    }
    
    override func apply(predicateContext: PredicateContext) -> PredicateApply {
        var left: ValueNode = self.left
        var right: ValueNode = self.right
        
        if let pathNode = left as? PathNode {
            var tmp = pathNode
            
            // SourceMac-Note: we support the "EXISTS" token, event if it's similar (and so redoundant) to don't use operator and right value.
            if relationalOperator == .EXISTS && tmp.existsCheck == false {
                tmp = PathNode(path: tmp.pathString,
                               prebuiltPath: tmp.path,
                               existsCheck: true,
                               shouldExists: tmp.shouldExists)
            }
            
            guard let result = tmp.evaluate(context: predicateContext) else {
                return .error
            }
            left = result
        }
        
        if let pathNode = right as? PathNode {
            guard let result = pathNode.evaluate(context: predicateContext) else {
                return .error
            }
            right = result
        }
        
        guard let evaluator = Evaluator(relationalOperator: relationalOperator) else {
            return .error
        }
        
        let result = evaluator.evaluate(left: left,
                                        right: right,
                                        context: predicateContext)
        
        switch result {
        case .true:
            return .true
        case .false:
            return .false
        case .error:
            return .error
        }
    }
}

/*

- (SMJPredicateApply)applyWithContext:(id <SMJPredicateContext>)context error:(NSError **)error
{

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
