import Foundation
import Hitch
import Spanker

extension ScanPathToken {

    @inlinable
    func walk(array path: PathToken,
              currentPath: Hitch,
              parentPath: Path,
              jsonArray: JsonElement,
              evaluationContext: EvaluationContext,
              predicate: ScanPredicate) -> EvaluationStatus {
        let evalPath = Hitch(capacity: currentPath.count + 32)

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
                Hitch.replace(hitch: evalPath, path: currentPath, index: idx)
                let result = walk(object: path,
                                  currentPath: evalPath,
                                  parentPath: newPath(object: jsonArray, item: evalObject),
                                  jsonDictionary: evalObject,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            } else if evalObject.type == .array {
                Hitch.replace(hitch: evalPath, path: currentPath, index: idx)
                let result = walk(array: path,
                                  currentPath: evalPath,
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

    @inlinable
    func walk(object: PathToken,
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
        let evalPath = Hitch(capacity: currentPath.count + 32)
        var idx = 0
        for property in jsonDictionary.keyArray {
            let propertyObject = jsonDictionary.valueArray[idx]
            idx += 1

            if propertyObject.type == .dictionary {
                Hitch.replace(hitch: evalPath,
                              path: currentPath,
                              property: property,
                              wrap: .singleQuote)
                let result = walk(object: object,
                                  currentPath: evalPath,
                                  parentPath: newPath(object: jsonDictionary, item: property),
                                  jsonDictionary: propertyObject,
                                  evaluationContext: evaluationContext,
                                  predicate: predicate)
                if result != .done {
                    return result
                }
            } else if propertyObject.type == .array {
                Hitch.replace(hitch: evalPath,
                              path: currentPath,
                              property: property,
                              wrap: .singleQuote)
                let result = walk(array: object,
                                  currentPath: evalPath,
                                  parentPath: newPath(object: jsonDictionary, item: property),
                                  jsonArray: propertyObject,
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
