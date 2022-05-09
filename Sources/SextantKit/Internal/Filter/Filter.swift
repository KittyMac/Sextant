import Foundation
import HitchKit

protocol Predicate: CustomStringConvertible {
    func apply(predicateContext: PredicateContext) -> EvaluatorResult
}

class Filter: Predicate {
    var description: String {
        fatalError("should be overwritten")
    }

    func apply(predicateContext: PredicateContext) -> EvaluatorResult {
        fatalError("should be overwritten")
    }
}
