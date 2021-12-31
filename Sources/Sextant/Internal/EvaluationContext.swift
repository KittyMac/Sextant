import Foundation
import Hitch
import Spanker

@usableFromInline
final class EvaluationContext {
    let options: EvaluationOptions

    var allValueTypeResults = [JsonType?]()
    var valueTypeResults = [JsonType?]()

    var allValueResults = JsonArray()
    var valueResults = JsonArray()
    var pathResults = [Hitch]()

    var evaluationCache = [Hitch: JsonAny]()

    var path: Path
    var rootJsonObject: JsonAny = nil
    var rootJsonElement: JsonElement = JsonElement.null

    var pathIsDefinite: Bool = false

    init(path: Path,
         rootJsonObject: JsonAny,
         options: EvaluationOptions) {

        self.path = path
        self.rootJsonObject = rootJsonObject
        self.options = options
        self.pathIsDefinite = path.isDefinite()
    }

    init(path: Path,
         rootJsonElement: JsonElement,
         options: EvaluationOptions) {

        self.path = path
        self.rootJsonElement = rootJsonElement
        self.options = options
        self.pathIsDefinite = path.isDefinite()
    }

    func add(path: Hitch,
             operation: Path,
             jsonObject: JsonAny) -> EvaluationStatus {

        if options.contains(.exportValues) {
            allValueTypeResults.append(nil)
            allValueResults.append(jsonObject)
            if jsonObject != nil {
                valueTypeResults.append(nil)
                valueResults.append(jsonObject)
            }
        }
        if options.contains(.exportPaths) {
            pathResults.append(Hitch(hitch: path))
        }

        return .done
    }

    func add(path: Hitch,
             operation: Path,
             jsonElement: JsonElement) -> EvaluationStatus {

        if options.contains(.exportValues) {
            let jsonObject = jsonElement.reify(true)
            allValueTypeResults.append(jsonElement.type)
            allValueResults.append(jsonObject)
            if jsonObject != nil {
                valueTypeResults.append(jsonElement.type)
                valueResults.append(jsonObject)
            }
        }
        if options.contains(.exportPaths) {
            pathResults.append(Hitch(hitch: path))
        }

        return .done
    }

    internal func jsonType() -> JsonType? {
        if pathIsDefinite {
            if valueTypeResults.count == 0 {
                return nil
            }

            return valueTypeResults[valueTypeResults.count - 1]
        }

        return .array
    }

    internal func jsonObject() -> JsonAny {
        if pathIsDefinite {
            if valueResults.count == 0 {
                return nil
            }

            return valueResults[valueResults.count - 1]
        }

        return valueResults
    }

    func resultsValues() -> JsonArray? {
        if pathIsDefinite {
            if valueResults.count == 0 {
                return []
            }

            return [valueResults[valueResults.count - 1]]
        }

        return valueResults
    }

    func allResultsValues() -> JsonArray? {
        if pathIsDefinite {
            if allValueResults.count == 0 {
                return []
            }

            return [allValueResults[allValueResults.count - 1]]
        }

        return allValueResults
    }

    func resultsPaths() -> [String] {
        if pathIsDefinite {
            if pathResults.count == 0 {
                return []
            }

            return [pathResults[pathResults.count - 1]].map { $0.toString() }
        }

        return pathResults.map { $0.toString() }
    }
}
