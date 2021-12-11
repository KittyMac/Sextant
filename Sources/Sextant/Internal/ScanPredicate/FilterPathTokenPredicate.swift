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
        return token.accept(jsonObject: jsonObject,
                            rootJsonObject: evaluationContext.rootJsonObject,
                            evaluationContext: evaluationContext)
    }
}
