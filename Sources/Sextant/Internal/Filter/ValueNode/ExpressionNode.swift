import Foundation
import Hitch

class ExpressionNode: Predicate {
    func apply(predicateContext: PredicateContext) -> PredicateApply {
        fatalError("should be overwritten")
    }
    
    var description: String {
        fatalError("should be overwritten")
    }
}
