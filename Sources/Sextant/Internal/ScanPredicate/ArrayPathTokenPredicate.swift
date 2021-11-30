import Foundation
import Hitch

class ArrayPathTokenPredicate: ScanPredicate {
    let token: ArrayPathToken
    
    init(token: ArrayPathToken) {
        self.token = token
    }
    
    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return (jsonObject as? JsonArray) != nil
    }
}

