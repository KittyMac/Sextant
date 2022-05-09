import Foundation
import HitchKit
import SpankerKit

class WildcardPathTokenPredicate: ScanPredicate {
    let token: WildcardPathToken

    init(token: WildcardPathToken) {
        self.token = token
    }

    @inlinable @inline(__always)
    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return true
    }

    @inlinable @inline(__always)
    override func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        return true
    }
}
