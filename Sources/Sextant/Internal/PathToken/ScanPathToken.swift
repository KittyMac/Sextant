import Foundation
import Hitch

class ScanPathToken: PathToken {

    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        guard let next = next else { return .done }
        
        return walk(path: next,
                    currentPath: currentPath,
                    parentPath: parentPath,
                    jsonObject: jsonObject,
                    evaluationContext: evaluationContext,
                    predicate: ScanPredicate.create(target: next, evaluationContext: evaluationContext))
    }
    
    override func isTokenDefinite() -> Bool {
        return false
    }
    
    override func pathFragment() -> String {
        return ".."
    }
    
    private func walk(path: PathToken,
                      currentPath: Hitch,
                      parentPath: Path,
                      jsonObject: JsonAny,
                      evaluationContext: EvaluationContext,
                      predicate: ScanPredicate) -> EvaluationStatus
    {
        if let dictionary = jsonObject as? JsonDictionary {
            return walk(object: path,
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonObject: dictionary,
                        evaluationContext: evaluationContext,
                        predicate: predicate)
        } else if let array = jsonObject as? JsonArray {
            return walk(array: path,
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonObject: array,
                        evaluationContext: evaluationContext,
                        predicate: predicate)
        }
        return .done
    }
    
    private func walk(array path: PathToken,
                      currentPath: Hitch,
                      parentPath: Path,
                      jsonObject: JsonArray,
                      evaluationContext: EvaluationContext,
                      predicate: ScanPredicate) -> EvaluationStatus
    {
        // Evaluate.
        if predicate.matchesJsonObject(jsonObject: jsonObject) {
            if let next = path.next {
                var idx = 0
                
                for evalObject in jsonObject {
                    let evalPath = Hitch.make(path: currentPath, index: idx)
                    
                    let result = next.evaluate(currentPath: evalPath,
                                               parentPath: parentPath,
                                               jsonObject: evalObject,
                                               evaluationContext: evaluationContext)
                    if result != .done {
                        return result
                    }
                    
                    idx += 1
                }
                
            } else {
                let result = path.evaluate(currentPath: currentPath,
                                           parentPath: parentPath,
                                           jsonObject: jsonObject,
                                           evaluationContext: evaluationContext)
                if result != .done {
                    return result
                }
            }
        }
        
        // Recurse.
        var idx = 0
        for evalObject in jsonObject {
            let evalPath = Hitch.make(path: currentPath, index: idx)
            let result = walk(path: path,
                              currentPath: evalPath,
                              parentPath: Path.newPath(object: jsonObject, item: evalObject),
                              jsonObject: evalObject,
                              evaluationContext: evaluationContext,
                              predicate: predicate)
            if result != .done {
                return result
            }
            idx += 1
        }
        
        return .done
    }
    
    private func walk(object: PathToken,
                      currentPath: Hitch,
                      parentPath: Path,
                      jsonObject: JsonDictionary,
                      evaluationContext: EvaluationContext,
                      predicate: ScanPredicate) -> EvaluationStatus
    {
        // Evaluate.
        if predicate.matchesJsonObject(jsonObject: jsonObject) {
            let result = object.evaluate(currentPath: currentPath,
                                         parentPath: parentPath,
                                         jsonObject: jsonObject,
                                         evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }
        
        // Recurse.
        for property in jsonObject.keys {
            guard let propertyObject = jsonObject[property] else { continue }
            let evalPath = Hitch.make(path: currentPath,
                                      property: property.hitch(),
                                      wrap: .singleQuote)
            let result = walk(path: object,
                              currentPath: evalPath,
                              parentPath: Path.newPath(object: jsonObject, item: property),
                              jsonObject: propertyObject,
                              evaluationContext: evaluationContext,
                              predicate: predicate)
            if result != .done {
                return result
            }
        }
        
        return .done
    }
}

