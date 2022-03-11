import Foundation
import Hitch
import Spanker

@usableFromInline
final class EvaluationContext {
    @usableFromInline
    var options: EvaluationOptions

    @usableFromInline
    var updateOperations = [Path]()

    @usableFromInline
    var allValueElementResults = [JsonElement]()
    @usableFromInline
    var valueElementResults = [JsonElement]()

    @usableFromInline
    var allValueResults = JsonArray()
    @usableFromInline
    var valueResults = JsonArray()
    @usableFromInline
    var pathResults = [Hitch]()

    @usableFromInline
    var evaluationCache = [Hitch: JsonAny]()

    @usableFromInline
    var path: Path

    @usableFromInline
    var rootJsonObject: JsonAny = nil

    @usableFromInline
    var rootJsonElement: JsonElement = JsonElement.null()

    @usableFromInline
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

    @inlinable @inline(__always)
    func add(path: Hitch,
             operation: Path,
             jsonObject: JsonAny) -> EvaluationStatus {

        if options.contains(.updateOperation) {
            updateOperations.append(operation)
        }

        if options.contains(.exportValues) {
            allValueElementResults.append(JsonElement.null())
            allValueResults.append(jsonObject)
            if jsonObject != nil {
                valueElementResults.append(JsonElement.null())
                valueResults.append(jsonObject)
            }
        }
        if options.contains(.exportPaths) {
            pathResults.append(Hitch(hitch: path))
        }

        return .done
    }

    @inlinable @inline(__always)
    func add(path: Hitch,
             operation: Path,
             jsonElement: JsonElement) -> EvaluationStatus {

        if options.contains(.updateOperation) {
            updateOperations.append(operation)
        }

        if options.contains(.exportValues) {
            let jsonObject = jsonElement.reify(true)
            allValueElementResults.append(jsonElement)
            allValueResults.append(jsonObject)
            if jsonObject != nil {
                valueElementResults.append(jsonElement)
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
            if valueElementResults.count == 0 {
                return nil
            }

            return valueElementResults[valueElementResults.count - 1].type
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

    func resultsElements() -> [JsonElement] {
        if pathIsDefinite {
            if valueElementResults.count == 0 {
                return []
            }

            return [valueElementResults[valueElementResults.count - 1]]
        }

        return valueElementResults
    }

    func allResultsElements() -> [JsonElement] {
        if pathIsDefinite {
            if allValueElementResults.count == 0 {
                return []
            }

            return [allValueElementResults[allValueElementResults.count - 1]]
        }

        return allValueElementResults
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
