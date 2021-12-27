import Foundation
import Hitch
import Spanker

class PropertyPathTokenPredicate: ScanPredicate {
    let token: PropertyPathToken
    let evaluationContext: EvaluationContext

    init(token: PropertyPathToken,
         evaluationContext: EvaluationContext) {
        self.token = token
        self.evaluationContext = evaluationContext
    }

    override func matchesJsonObject(jsonObject: JsonAny) -> Bool {
        guard let dictionary = jsonObject as? JsonDictionary else { return false }

        if token.isTokenDefinite() == false {
            return true
        }

        for property in token.properties {
            if dictionary[property.description] == nil {
                return false
            }
        }

        return true
    }

    override func matchesJsonElement(jsonElement: JsonElement) -> Bool {
        guard jsonElement.type == .dictionary else { return false }

        if token.isTokenDefinite() == false {
            return true
        }

        for property in token.properties {
            if jsonElement.contains(key: property) == false {
                return false
            }
        }

        return true
    }
}
