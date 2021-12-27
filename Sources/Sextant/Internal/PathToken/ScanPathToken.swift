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
                        scratchPath: Hitch(capacity: 512),
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonObject: array,
                        evaluationContext: evaluationContext,
                        predicate: ScanPredicate.create(target: next, evaluationContext: evaluationContext))
        }
        if let dictionary = jsonObject as? JsonDictionary {
            return walk(object: next,
                        scratchPath: Hitch(capacity: 512),
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
                        scratchPath: Hitch(capacity: 512),
                        currentPath: currentPath,
                        parentPath: parentPath,
                        jsonArray: jsonElement,
                        evaluationContext: evaluationContext,
                        predicate: ScanPredicate.create(target: next, evaluationContext: evaluationContext))
        }
        if jsonElement.type == .dictionary {
            return walk(object: next,
                        scratchPath: Hitch(capacity: 512),
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
              scratchPath: Hitch,
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
                Hitch.replace(hitch: scratchPath, path: currentPath, index: idx)
                let result = walk(object: path,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonObject, item: evalObject),
                                  jsonObject: dictionary,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            } else if let array = evalObject as? JsonArray {
                Hitch.replace(hitch: scratchPath, path: currentPath, index: idx)
                let result = walk(array: path,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonObject, item: evalObject),
                                  jsonObject: array,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            }

            idx += 1
        }

        return .done
    }

    @inlinable @inline(__always)
    func walk(object: PathToken,
              scratchPath: Hitch,
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
                Hitch.replace(hitch: scratchPath,
                              path: currentPath,
                              property: property,
                              wrap: .singleQuote)
                let result = walk(object: object,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonObject, item: property),
                                  jsonObject: dictionary,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            } else if let array = propertyObject as? JsonArray {
                Hitch.replace(hitch: scratchPath,
                              path: currentPath,
                              property: property,
                              wrap: .singleQuote)
                let result = walk(array: object,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonObject, item: property),
                                  jsonObject: array,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            }
        }

        return .done
    }
}
