import Foundation
import Hitch

final class PredicateContext {
    var jsonObject: JsonAny
    var rootJsonObject: JsonAny
    var pathCache: [Hitch: JsonAny]
    
    init(jsonObject: JsonAny,
         rootJsonObject: JsonAny,
         pathCache: [Hitch: JsonAny]) {
        self.jsonObject = jsonObject
        self.rootJsonObject = rootJsonObject
        self.pathCache = pathCache
    }
    
    func evaluate(path: Path) -> JsonAny {
        var result: JsonAny = nil
        
        if path.isRootPath() {
            let pathString = path.description.hitch()
            if let obj = pathCache[pathString] {
                result = obj
            } else {
                guard let evaluationContext = path.evaluate(jsonObject: rootJsonObject,
                                                            rootJsonObject: rootJsonObject) else {
                    return nil
                }
                
                result = evaluationContext.jsonObject()
                if let result = result {
                    pathCache[pathString] = result
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
}
