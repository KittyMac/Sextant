import Foundation
import Hitch

class FilterPathTokenPredicate: ScanPredicate {
    let token: PredicatePathToken
    let evaluationContext: EvaluationContext
    
    init(token: PredicatePathToken,
         evaluationContext: EvaluationContext) {
        self.token = token
        self.evaluationContext = evaluationContext
    }

    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        fatalError("TO BE IMPLEMENTED")
        // return [_predicatePathToken acceptJsonObject:jsonObject rootJsonObject:_ctx.rootJsonObject configuration:_ctx.configuration evaluationContext:_ctx];
    }
}
