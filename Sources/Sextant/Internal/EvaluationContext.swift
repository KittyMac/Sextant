import Foundation
import Hitch
import Spanker

final class EvaluationContext {
    var updateOperations = [Path]()

    var allValueResults = JsonArray()
    var valueResults = JsonArray()
    var pathResults = [String]()

    var evaluationCache = [Hitch: JsonAny]()

    var path: Path
    var rootJsonObject: JsonAny = nil
    var rootJsonElement: JsonElement = JsonElement.null

    init(path: Path,
         rootJsonObject: JsonAny) {

        self.path = path
        self.rootJsonObject = rootJsonObject
    }

    init(path: Path,
         rootJsonElement: JsonElement) {

        self.path = path
        self.rootJsonElement = rootJsonElement
    }

    func add(path: Hitch,
             operation: Path,
             jsonObject: JsonAny) -> EvaluationStatus {

        allValueResults.append(jsonObject)
        if jsonObject != nil {
            valueResults.append(jsonObject)
        }
        pathResults.append(path.description)

        return .done
    }

    func add(path: Hitch,
             operation: Path,
             jsonElement: JsonElement) -> EvaluationStatus {
        return add(path: path,
                   operation: operation,
                   jsonObject: jsonElement.reify())
    }

    internal func jsonObject() -> JsonAny {
        if path.isDefinite() {
            if valueResults.count == 0 {
                return nil
            }

            return valueResults[valueResults.count - 1]
        }

        return valueResults
    }

    func resultsValues() -> JsonArray? {
        if path.isDefinite() {
            if valueResults.count == 0 {
                return []
            }

            return [valueResults[valueResults.count - 1]]
        }

        return valueResults
    }

    func allResultsValues() -> JsonArray? {
        if path.isDefinite() {
            if allValueResults.count == 0 {
                return []
            }

            return [allValueResults[allValueResults.count - 1]]
        }

        return allValueResults
    }

    func resultsPaths() -> JsonArray? {
        if path.isDefinite() {
            if pathResults.count == 0 {
                return []
            }

            return [pathResults[pathResults.count - 1]]
        }

        return pathResults
    }
}
