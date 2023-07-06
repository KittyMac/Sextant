import Foundation
import Hitch

class LogicalExpressionNode: ExpressionNode {
    var op: LogicalOperator
    var chain: [ExpressionNode]

    init(op: LogicalOperator, nodes: [ExpressionNode]) {
        self.op = op
        self.chain = nodes
    }

    @inlinable
    override func apply(predicateContext: PredicateContext) -> EvaluatorResult {
        if op == LogicalOperator.logicalOperatorOR() {
            for expression in chain {
                let result = expression.apply(predicateContext: predicateContext)
                if result == .error {
                    return result
                } else if result == .true {
                    return result
                }
            }
            return .false
        } else if op == LogicalOperator.logicalOperatorAND() {
            for expression in chain {
                let result = expression.apply(predicateContext: predicateContext)
                if result == .error {
                    return result
                } else if result == .false {
                    return result
                }
            }
            return .true
        } else {
            let expression = chain[0]
            let result = expression.apply(predicateContext: predicateContext)
            if result == .error {
                return result
            }

            if result == .true {
                return .false
            }
            return .true
        }
    }

    override var description: String {
        var result = ""
        let delimiter = " \(op.stringOperator) "

        result.append("(")
        result.append( chain.map { $0.description }.joined(separator: delimiter) )
        result.append(")")

        return result
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
