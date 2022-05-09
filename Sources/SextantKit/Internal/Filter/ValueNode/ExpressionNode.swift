import Foundation
import HitchKit

class ExpressionNode: Predicate {
    func apply(predicateContext: PredicateContext) -> EvaluatorResult {
        fatalError("should be overwritten")
    }

    var description: String {
        fatalError("should be overwritten")
    }
}
