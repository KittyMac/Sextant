import Foundation
import Hitch
import Spanker

@usableFromInline
final class EvaluationContext {
    var updateOperations = [Path]()

    var allValueResults = JsonArray()
    var valueResults = JsonArray()
    var pathResults = [Hitch]()

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
        pathResults.append(Hitch(hitch: path))

        return .done
    }

    func add(path: Hitch,
             operation: Path,
             jsonElement: JsonElement) -> EvaluationStatus {

        let jsonObject = jsonElement.reify(true)

        allValueResults.append(jsonObject)
        if jsonObject != nil {
            valueResults.append(jsonObject)
        }
        pathResults.append(Hitch(hitch: path))

        return .done
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

    func resultsPaths() -> [String] {
        if path.isDefinite() {
            if pathResults.count == 0 {
                return []
            }

            return [pathResults[pathResults.count - 1]].map { $0.toString() }
        }

        return pathResults.map { $0.toString() }
    }
}
