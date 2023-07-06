import Foundation
import Hitch
import Spanker

class PropertyPathToken: PathToken {
    var property: Hitch?
    var properties: [Hitch]
    var wrap: UInt8

    init?(properties: [Hitch],
          wrap: UInt8) {
        if properties.count == 0 {
            error("Empty properties")
            return nil
        }

        self.properties = properties
        self.wrap = wrap

        if properties.count == 1 {
            property = properties.first
        }
    }

    @inlinable
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        guard let jsonObject = jsonObject as? JsonDictionary else {
            if isUpstreamDefinite() == false {
                return .done
            }
            return .aborted
        }

        for property in properties {
            let result = handle(property: property,
                                currentPath: currentPath,
                                jsonObject: jsonObject,
                                evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }

        return .done
    }

    @inlinable
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonElement: JsonElement,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {

        guard jsonElement.type == .dictionary else {
            if isUpstreamDefinite() == false {
                return .done
            }
            return .aborted
        }

        if let property = property {
            return handle(property: property,
                          currentPath: currentPath,
                          jsonElement: jsonElement,
                          evaluationContext: evaluationContext)
        }

        for property in properties {
            let result = handle(property: property,
                                currentPath: currentPath,
                                jsonElement: jsonElement,
                                evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }

        return .done
    }

    override func isTokenDefinite() -> Bool {
        // in case of leaf multiprops will be merged, so it's kinda definite
        return properties.count == 1
    }

    override func pathFragment() -> String {
        return "[\(properties.joined(delimiter: .comma, wrap: wrap))]"
    }
}
