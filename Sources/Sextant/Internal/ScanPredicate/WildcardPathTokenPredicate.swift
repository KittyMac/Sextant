import Foundation
import Hitch
import Spanker

class WildcardPathTokenPredicate: ScanPredicate {
    let token: WildcardPathToken

    init(token: WildcardPathToken) {
        self.token = token
    }

    @inlinable
    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return true
    }

    @inlinable
    override func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        return true
    }
}
