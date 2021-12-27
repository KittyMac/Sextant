import Foundation
import Hitch
import Spanker

extension ScanPathToken {

    @inlinable @inline(__always)
    func walk(array path: PathToken,
              scratchPath: Hitch,
              currentPath: Hitch,
              parentPath: Path,
              jsonArray: JsonElement,
              evaluationContext: EvaluationContext,
              predicate: ScanPredicate) -> EvaluationStatus {
        // Evaluate.
        if predicate.matchesJsonElement(jsonElement: jsonArray) {
            let result = path.evaluate(currentPath: currentPath,
                                       parentPath: parentPath,
                                       jsonElement: jsonArray,
                                       evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }

        // Recurse.
        var idx = 0
        for evalObject in jsonArray.valueArray {

            if evalObject.type == .dictionary {
                Hitch.replace(hitch: scratchPath, path: currentPath, index: idx)
                let result = walk(object: path,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonArray, item: evalObject),
                                  jsonDictionary: evalObject,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            } else if evalObject.type == .array {
                Hitch.replace(hitch: scratchPath, path: currentPath, index: idx)
                let result = walk(array: path,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonArray, item: evalObject),
                                  jsonArray: evalObject,
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
              jsonDictionary: JsonElement,
              evaluationContext: EvaluationContext,
              predicate: ScanPredicate) -> EvaluationStatus {
        // Evaluate.
        if predicate.matchesJsonElement(jsonElement: jsonDictionary) {
            let result = object.evaluate(currentPath: currentPath,
                                         parentPath: parentPath,
                                         jsonElement: jsonDictionary,
                                         evaluationContext: evaluationContext)
            if result != .done {
                return result
            }
        }

        // Recurse.
        var idx = 0
        for propertyObject in jsonDictionary.valueArray {

            if propertyObject.type == .dictionary {
                let property = jsonDictionary.keyArray[idx]
                Hitch.replace(hitch: scratchPath,
                              path: currentPath,
                              property: property,
                              wrap: .singleQuote)
                let result = walk(object: object,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonDictionary, item: property),
                                  jsonDictionary: propertyObject,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            } else if propertyObject.type == .array {
                let property = jsonDictionary.keyArray[idx]
                Hitch.replace(hitch: scratchPath,
                              path: currentPath,
                              property: property,
                              wrap: .singleQuote)
                let result = walk(array: object,
                                  scratchPath: scratchPath,
                                  currentPath: scratchPath,
                                  parentPath: newPath(object: jsonDictionary, item: property),
                                  jsonArray: propertyObject,
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
}
