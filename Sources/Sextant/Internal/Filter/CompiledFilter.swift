import Foundation
import Hitch

class CompiledFilter: Filter {
    let predicate: Predicate

    init(predicate: Predicate) {
        self.predicate = predicate
    }

    override func apply(predicateContext: PredicateContext) -> PredicateApply {
        return predicate.apply(predicateContext: predicateContext)
    }

    override var description: String {
        let predicateString = predicate.description
        if predicateString.hasPrefix("(") {
            return "[?\(predicateString)]"
        } else {
            return "[?(\(predicateString))]"
        }
    }
}
