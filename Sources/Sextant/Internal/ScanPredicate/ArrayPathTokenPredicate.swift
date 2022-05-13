import Foundation
import Hitch
import Spanker

class ArrayPathTokenPredicate: ScanPredicate {
    let token: ArrayPathToken

    init(token: ArrayPathToken) {
        self.token = token
    }

    @inlinable @inline(__always)
    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        return (jsonObject as? JsonArray) != nil
    }

    @inlinable @inline(__always)
    override func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        return jsonElement.type == .array
    }
}
