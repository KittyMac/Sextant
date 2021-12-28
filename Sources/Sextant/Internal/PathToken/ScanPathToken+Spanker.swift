import Foundation
import Hitch
import Spanker

extension ScanPathToken {

    @inlinable @inline(__always)
    func walk(array path: PathToken,
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
                let result = Hitch.appending(hitch: currentPath, index: idx) {
                    walk(object: path,
                         currentPath: currentPath,
                         parentPath: newPath(object: jsonArray, item: evalObject),
                         jsonDictionary: evalObject,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }

                if result != .done {
                    return result
                }

            } else if evalObject.type == .array {
                let result = Hitch.appending(hitch: currentPath, index: idx) {
                    walk(array: path,
                         currentPath: currentPath,
                         parentPath: newPath(object: jsonArray, item: evalObject),
                         jsonArray: evalObject,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }
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
                let result = Hitch.appending(hitch: currentPath,
                                             property: property,
                                             wrap: .singleQuote) {
                    walk(object: object,
                         currentPath: currentPath,
                         parentPath: newPath(object: jsonDictionary, item: property),
                         jsonDictionary: propertyObject,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }
                if result != .done {
                    return result
                }
            } else if propertyObject.type == .array {
                let property = jsonDictionary.keyArray[idx]
                let result = Hitch.appending(hitch: currentPath,
                                             property: property,
                                             wrap: .singleQuote) {
                    walk(array: object,
                         currentPath: currentPath,
                         parentPath: newPath(object: jsonDictionary, item: property),
                         jsonArray: propertyObject,
                         evaluationContext: evaluationContext,
                         predicate: predicate)
                }
                if result != .done {
                    return result
                }
            }

            idx += 1
        }

        return .done
    }
}
