import Foundation
import Hitch
import Spanker

class ArrayPathTokenPredicate: ScanPredicate {
    let token: ArrayPathToken

    init(token: ArrayPathToken) {
        self.token = token
    }

    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return (jsonObject as? JsonArray) != nil
    }

    override func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        return jsonElement.type == .array
    }
}
