import Foundation
import Hitch
import Spanker

class ScanPathToken: PathToken {

    @inlinable @inline(__always)
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        guard let next = next else { return .done }

        if let array = jsonObject as? JsonArray {
            return walk(array: next,
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonObject: array,
                        evaluationContext: evaluationContext,
                        predicate: ScanPredicate.create(target: next, evaluationContext: evaluationContext))
        }
        if let dictionary = jsonObject as? JsonDictionary {
            return walk(object: next,
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonObject: dictionary,
                        evaluationContext: evaluationContext,
                        predicate: ScanPredicate.create(target: next, evaluationContext: evaluationContext))
        }
        return .done
    }

    @inlinable @inline(__always)
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonElement: JsonElement,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        guard let next = next else { return .done }

        if jsonElement.type == .array {
            return walk(array: next,
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonArray: jsonElement,
                        evaluationContext: evaluationContext,
                        predicate: ScanPredicate.create(target: next, evaluationContext: evaluationContext))
        }
        if jsonElement.type == .dictionary {
            return walk(object: next,
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonDictionary: jsonElement,
                        evaluationContext: evaluationContext,
                        predicate: ScanPredicate.create(target: next, evaluationContext: evaluationContext))
        }
        return .done
    }

    override func isTokenDefinite() -> Bool {
        return false
    }

    override func pathFragment() -> String {
        return ".."
    }

    @inlinable @inline(__always)
    func walk(array path: PathToken,
              currentPath: Hitch,
              parentPath: Path,
              jsonObject: JsonArray,
              evaluationContext: EvaluationContext,
              predicate: ScanPredicate) -> EvaluationStatus {
        // Evaluate.
        if predicate.matchesJsonObject(jsonObject: jsonObject) {
            let result = path.evaluate(currentPath: currentPath,
                                       parentPath: parentPath,
                                       jsonObject: jsonObject,
                                       evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }

        // Recurse.
        var idx = 0
        for evalObject in jsonObject {

            if let dictionary = evalObject as? JsonDictionary {
                let result = Hitch.appending(hitch: currentPath, index: idx) {
                    walk(object: path,
                         currentPath: currentPath,
                         parentPath: newPath(array: jsonObject, index: idx, item: evalObject),
                         jsonObject: dictionary,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }
                if result != .done {
                    return result
                }
            } else if let array = evalObject as? JsonArray {
                let result = Hitch.appending(hitch: currentPath, index: idx) {
                    walk(array: path,
                         currentPath: currentPath,
                         parentPath: newPath(array: jsonObject, index: idx, item: evalObject),
                         jsonObject: array,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }
                if result != .done {
                    return result
                }
            }

            idx += 1
        }
        
        // Evaluate my non-walkable children
        if predicate.isWildcardFilterPath() {
            for evalObject in jsonObject {
                guard evalObject is JsonDictionary == false else { continue }
                guard evalObject is JsonArray == false else { continue }
                
                if predicate.matchesJsonObject(jsonObject: evalObject) {
                    let result = path.evaluate(currentPath: currentPath,
                                               parentPath: parentPath,
                                               jsonObject: evalObject,
                                               evaluationContext: evaluationContext)
                    if result != .done {
                        return result
                    }
                }
            }
        }

        return .done
    }

    @inlinable @inline(__always)
    func walk(object: PathToken,
              currentPath: Hitch,
              parentPath: Path,
              jsonObject: JsonDictionary,
              evaluationContext: EvaluationContext,
              predicate: ScanPredicate) -> EvaluationStatus {
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
        for (property, propertyObject) in jsonObject {
            if let dictionary = propertyObject as? JsonDictionary {
                let result = Hitch.appending(hitch: currentPath,
                                             property: property,
                                             wrap: .singleQuote) {
                    walk(object: object,
                         currentPath: currentPath,
                         parentPath: newPath(dictionary: jsonObject, property: property),
                         jsonObject: dictionary,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }
                if result != .done {
                    return result
                }
            } else if let array = propertyObject as? JsonArray {
                let result = Hitch.appending(hitch: currentPath,
                                             property: property,
                                             wrap: .singleQuote) {
                    walk(array: object,
                         currentPath: currentPath,
                         parentPath: newPath(dictionary: jsonObject, property: property),
                         jsonObject: array,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }
                if result != .done {
                    return result
                }
            }
        }
        
        // Evaluate my non-walkable children
        if predicate.isWildcardFilterPath() {
            for (_, propertyObject) in jsonObject {
                guard propertyObject is JsonDictionary == false else { continue }
                guard propertyObject is JsonArray == false else { continue }
                
                if predicate.matchesJsonObject(jsonObject: propertyObject) {
                    let result = object.evaluate(currentPath: currentPath,
                                                 parentPath: parentPath,
                                                 jsonObject: propertyObject,
                                                 evaluationContext: evaluationContext)
                    if result != .done {
                        return result
                    }
                }
            }
        }

        return .done
    }
}
