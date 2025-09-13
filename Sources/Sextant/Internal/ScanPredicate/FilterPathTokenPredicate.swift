import Foundation
import Hitch
import Spanker

class FilterPathTokenPredicate: ScanPredicate {
    let token: PredicatePathToken
    let evaluationContext: EvaluationContext
    let isWildcardFilter: Bool

    init(token: PredicatePathToken,
         evaluationContext: EvaluationContext) {
        self.token = token
        self.evaluationContext = evaluationContext
        self.isWildcardFilter = (token.description == "[?]")
    }
    
    
    override func isWildcardFilterPath() -> Bool {
        return isWildcardFilter
    }

    
    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return token.accept(jsonObject: jsonObject,
                            rootJsonObject: evaluationContext.rootJsonObject,
                            evaluationContext: evaluationContext)
    }

    
    override func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        return token.accept(jsonElement: jsonElement,
                            rootJsonElement: evaluationContext.rootJsonElement,
                            evaluationContext: evaluationContext)
    }
}
