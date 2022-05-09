import Foundation
import HitchKit
import SpankerKit

class ScanPredicate {
    class func create(target: PathToken, evaluationContext: EvaluationContext) -> ScanPredicate {
        if let target = target as? PropertyPathToken {
            return PropertyPathTokenPredicate(token: target,
                                              evaluationContext: evaluationContext)
        }
        if let target = target as? ArrayPathToken {
            return ArrayPathTokenPredicate(token: target)
        }
        if let target = target as? WildcardPathToken {
            return WildcardPathTokenPredicate(token: target)
        }
        if let target = target as? PredicatePathToken {
            return FilterPathTokenPredicate(token: target,
                                            evaluationContext: evaluationContext)
        }
        return FakePredicate()
    }

    @inlinable @inline(__always)
    func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return false
    }

    @inlinable @inline(__always)
    func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        return false
    }
}
