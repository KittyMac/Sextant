import Foundation
import Hitch

enum PredicateApply {
    case `true`
    case `false`
    case error
}

protocol Predicate: CustomStringConvertible {
    func apply(predicateContext: PredicateContext) -> PredicateApply
}

class Filter: Predicate {
    var description: String {
        fatalError("should be overwritten")
    }

    func apply(predicateContext: PredicateContext) -> PredicateApply {
        fatalError("should be overwritten")
    }
}
