import Foundation
import Hitch

class WildcardPathTokenPredicate: ScanPredicate {
    let token: WildcardPathToken
    
    init(token: WildcardPathToken) {
        self.token = token
    }
    
    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return true
    }
}
