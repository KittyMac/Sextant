import Foundation
import Hitch
import Spanker

struct PredicateContext {
    var jsonObject: JsonAny = nil
    var rootJsonObject: JsonAny = nil
    var pathObjectCache: [Hitch: JsonAny] = [:]

    var jsonElement: JsonElement = JsonElement.null()
    var rootJsonElement: JsonElement = JsonElement.null()

    init(jsonObject: JsonAny,
         rootJsonObject: JsonAny,
         pathCache: [Hitch: JsonAny]) {
        self.jsonObject = jsonObject
        self.rootJsonObject = rootJsonObject
        self.pathObjectCache = pathCache
    }

    init(jsonElement: JsonElement,
         rootJsonElement: JsonElement,
         pathCache: [Hitch: JsonAny]) {
        self.jsonElement = jsonElement
        self.rootJsonElement = rootJsonElement
    }

    @inlinable
    func evaluate(path: Path, options: EvaluationOptions) -> (JsonAny, JsonType?) {
        if jsonObject != nil {
            return evaluate(jsonObject: path, options: options)
        }
        return evaluate(jsonElement: path, options: options)
    }

    @inlinable
    func evaluate(jsonObject path: Path, options: EvaluationOptions) -> (JsonAny, JsonType?) {
        var result: JsonAny = nil

        if path.isRootPath() {
            guard let evaluationContext = path.evaluate(jsonObject: rootJsonObject,
                                                        rootJsonObject: rootJsonObject,
                                                        options: options) else {
                return (nil, .null)
            }

            result = evaluationContext.jsonObject()
        } else {
            guard let evaluationContext = path.evaluate(jsonObject: jsonObject,
                                                        rootJsonObject: rootJsonObject,
                                                        options: options) else {
                return (nil, .null)
            }
            result = evaluationContext.jsonObject()
        }

        return (result, nil)
    }

    @inlinable
    func evaluate(jsonElement path: Path, options: EvaluationOptions) -> (JsonAny, JsonType?) {
        var result: JsonAny = nil
        var resultType: JsonType?

        if path.isRootPath() {
            guard let evaluationContext = path.evaluate(jsonElement: rootJsonElement,
                                                        rootJsonElement: rootJsonElement,
                                                        options: options) else {
                return (nil, .null)
            }

            result = evaluationContext.jsonObject()
            resultType = evaluationContext.jsonType()
        } else {
            guard let evaluationContext = path.evaluate(jsonElement: jsonElement,
                                                        rootJsonElement: rootJsonElement,
                                                        options: options) else {
                return (nil, .null)
            }
            result = evaluationContext.jsonObject()
            resultType = evaluationContext.jsonType()
        }

        return (result, resultType)
    }
}
