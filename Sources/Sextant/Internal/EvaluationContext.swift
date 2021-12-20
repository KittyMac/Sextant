import Foundation
import Hitch

final class EvaluationContext {
    var updateOperations = [Path]()

    var allValueResults = JsonArray()
    var valueResults = JsonArray()
    var pathResults = [String]()
    var resultIndex = 0

    var evaluationCache = [Hitch: JsonAny]()

    var path: Path
    var rootJsonObject: JsonAny

    init(path: Path,
         rootJsonObject: JsonAny) {

        self.path = path
        self.rootJsonObject = rootJsonObject
    }

    func add(path: Hitch,
             operation: Path,
             jsonObject: JsonAny) -> EvaluationStatus {

        allValueResults.append(jsonObject)
        if jsonObject != nil {
            valueResults.append(jsonObject)
        }
        pathResults.append(path.description)

        resultIndex += 1
        return .done
    }

    func jsonObject() -> JsonAny {
        if path.isDefinite() {
            if resultIndex == 0 || valueResults.count == 0 {
                error("No results for path: \(path)")
                return nil
            }

            return valueResults[valueResults.count - 1]
        }

        return valueResults
    }

    func resultsValues() -> JsonArray? {
        if path.isDefinite() {
            if resultIndex == 0 || valueResults.count == 0 {
                error("No results for path: \(path)")
                return nil
            }

            return [valueResults[valueResults.count - 1]]
        }

        return valueResults
    }

    func allResultsValues() -> JsonArray? {
        if path.isDefinite() {
            if resultIndex == 0 || allValueResults.count == 0 {
                error("No results for path: \(path)")
                return nil
            }

            return [allValueResults[allValueResults.count - 1]]
        }

        return allValueResults
    }

    func resultsPaths() -> JsonArray? {
        if path.isDefinite() {
            if resultIndex == 0 || valueResults.count == 0 {
                error("No results for path: \(path)")
                return nil
            }

            return [pathResults[pathResults.count - 1]]
        }

        return pathResults
    }
}
