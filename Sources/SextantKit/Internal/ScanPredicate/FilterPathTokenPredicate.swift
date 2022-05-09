import Foundation
import HitchKit
import SpankerKit

class FilterPathTokenPredicate: ScanPredicate {
    let token: PredicatePathToken
    let evaluationContext: EvaluationContext

    init(token: PredicatePathToken,
         evaluationContext: EvaluationContext) {
        self.token = token
        self.evaluationContext = evaluationContext
    }

    @inlinable @inline(__always)
    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return token.accept(jsonObject: jsonObject,
                            rootJsonObject: evaluationContext.rootJsonObject,
                            evaluationContext: evaluationContext)
    }

    @inlinable @inline(__always)
    override func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        return token.accept(jsonElement: jsonElement,
                            rootJsonElement: evaluationContext.rootJsonElement,
                            evaluationContext: evaluationContext)
    }
}
