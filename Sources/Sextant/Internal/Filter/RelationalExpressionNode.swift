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

    @inlinable
    override func apply(predicateContext: PredicateContext) -> EvaluatorResult {
        // Note: this is broken out verbosely to avoid performance problems caused by copy of a value type.
        if left.typeName != .path && right.typeName != .path {
            return Evaluator.evaluate(relationalOperator: relationalOperator,
                                      left: left,
                                      right: right,
                                      context: predicateContext)
        } else if left.typeName == .path && right.typeName != .path {
            if relationalOperator == .EXISTS {
                guard let left = left.copyForExistsCheck().evaluate(context: predicateContext, options: .default) else { return .error }
                return Evaluator.evaluate(relationalOperator: relationalOperator,
                                          left: left,
                                          right: right,
                                          context: predicateContext)
            } else {
                guard let left = left.evaluate(context: predicateContext, options: .default) else { return .error }
                return Evaluator.evaluate(relationalOperator: relationalOperator,
                                          left: left,
                                          right: right,
                                          context: predicateContext)
            }
        } else if left.typeName != .path && right.typeName == .path {
            guard let right = right.evaluate(context: predicateContext, options: .default) else { return .error }
           return Evaluator.evaluate(relationalOperator: relationalOperator,
                                     left: left,
                                     right: right,
                                     context: predicateContext)
        } else {
            guard let right = right.evaluate(context: predicateContext, options: .default) else { return .error }
            if relationalOperator == .EXISTS {
                guard let left = left.copyForExistsCheck().evaluate(context: predicateContext, options: .default) else { return .error }
                return Evaluator.evaluate(relationalOperator: relationalOperator,
                                          left: left,
                                          right: right,
                                          context: predicateContext)
            } else {
                guard let left = left.evaluate(context: predicateContext, options: .default) else { return .error }
                return Evaluator.evaluate(relationalOperator: relationalOperator,
                                          left: left,
                                          right: right,
                                          context: predicateContext)
            }
        }
    }

    override var description: String {
        if relationalOperator == .EXISTS {
            return left.description
        } else {
            return "\(left) \(relationalOperator.hitch()) \(right)"
        }
    }
}
