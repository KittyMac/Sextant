import Foundation
import Hitch
import Spanker

final class PredicateContext {
    var jsonObject: JsonAny = nil
    var rootJsonObject: JsonAny = nil
    var pathObjectCache: [Hitch: JsonAny] = [:]

    var jsonElement: JsonElement = JsonElement.null
    var rootJsonElement: JsonElement = JsonElement.null
    var pathElementCache: [Hitch: JsonAny] = [:]

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
        self.pathElementCache = pathCache
    }

    func evaluate(path: Path, options: EvaluationOptions) -> JsonAny {
        if jsonObject != nil {
            return evaluate(jsonObject: path, options: options)
        }
        return evaluate(jsonElement: path, options: options)
    }

    fileprivate func evaluate(jsonObject path: Path, options: EvaluationOptions) -> JsonAny {
        var result: JsonAny = nil

        if path.isRootPath() {
            let pathString = path.description.hitch()
            if let obj = pathObjectCache[pathString] {
                result = obj
            } else {
                guard let evaluationContext = path.evaluate(jsonObject: rootJsonObject,
                                                            rootJsonObject: rootJsonObject,
                                                            options: options) else {
                    return nil
                }

                result = evaluationContext.jsonObject()
                if let result = result {
                    pathObjectCache[pathString] = result
                }
            }
        } else {
            guard let evaluationContext = path.evaluate(jsonObject: jsonObject,
                                                        rootJsonObject: rootJsonObject,
                                                        options: options) else {
                return nil
            }
            result = evaluationContext.jsonObject()
        }

        return result
    }

    fileprivate func evaluate(jsonElement path: Path, options: EvaluationOptions) -> JsonAny {
        var result: JsonAny = nil

        if path.isRootPath() {
            let pathString = path.description.hitch()
            if let obj = pathElementCache[pathString] {
                result = obj
            } else {
                guard let evaluationContext = path.evaluate(jsonElement: rootJsonElement,
                                                            rootJsonElement: rootJsonElement,
                                                            options: options) else {
                    return nil
                }

                result = evaluationContext.jsonObject()
                if let result = result {
                    pathElementCache[pathString] = result
                }
            }
        } else {
            guard let evaluationContext = path.evaluate(jsonElement: jsonElement,
                                                        rootJsonElement: rootJsonElement,
                                                        options: options) else {
                return nil
            }
            result = evaluationContext.jsonObject()
        }

        return result
    }
}
