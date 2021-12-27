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

    func evaluate(path: Path) -> JsonAny {
        if jsonObject != nil {
            return evaluate(jsonObject: path)
        }
        return evaluate(jsonElement: path)
    }

    fileprivate func evaluate(jsonObject path: Path) -> JsonAny {
        var result: JsonAny = nil

        if path.isRootPath() {
            let pathString = path.description.hitch()
            if let obj = pathObjectCache[pathString] {
                result = obj
            } else {
                guard let evaluationContext = path.evaluate(jsonObject: rootJsonObject,
                                                            rootJsonObject: rootJsonObject) else {
                    return nil
                }

                result = evaluationContext.jsonObject()
                if let result = result {
                    pathObjectCache[pathString] = result
                }
            }
        } else {
            guard let evaluationContext = path.evaluate(jsonObject: jsonObject,
                                                        rootJsonObject: rootJsonObject) else {
                return nil
            }
            result = evaluationContext.jsonObject()
        }

        return result
    }

    fileprivate func evaluate(jsonElement path: Path) -> JsonAny {
        var result: JsonAny = nil

        if path.isRootPath() {
            let pathString = path.description.hitch()
            if let obj = pathElementCache[pathString] {
                result = obj
            } else {
                guard let evaluationContext = path.evaluate(jsonElement: rootJsonElement,
                                                            rootJsonElement: rootJsonElement) else {
                    return nil
                }

                result = evaluationContext.jsonObject()
                if let result = result {
                    pathElementCache[pathString] = result
                }
            }
        } else {
            guard let evaluationContext = path.evaluate(jsonElement: jsonElement,
                                                        rootJsonElement: rootJsonElement) else {
                return nil
            }
            result = evaluationContext.jsonObject()
        }

        return result
    }
}
