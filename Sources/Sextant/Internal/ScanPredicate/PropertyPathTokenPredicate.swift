import Foundation
import Hitch

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
}
