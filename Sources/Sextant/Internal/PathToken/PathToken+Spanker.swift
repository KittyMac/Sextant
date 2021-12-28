import Foundation
import Hitch
import Spanker

extension PathToken {

    @inlinable
    func checkArray(currentPath: Hitch,
                    jsonElement: JsonElement,
                    evaluationContext: EvaluationContext) -> ArrayPathCheck {
        if jsonElement.type == .array {
            return .handle
        }

        if isUpstreamDefinite() == false {
            return .skip
        }

        return .skip
    }

    @inlinable
    func handle(arrayIndex: Int,
                currentPath: Hitch,
                jsonElement: JsonElement,
                evaluationContext: EvaluationContext) -> EvaluationStatus {

        let path = nullPath()

        let effectiveIndex = arrayIndex < 0 ? jsonElement.count + arrayIndex : arrayIndex

        guard effectiveIndex >= 0 && effectiveIndex < jsonElement.count else {
            let result = Hitch.appending(hitch: currentPath, index: arrayIndex) {
                evaluationContext.add(path: currentPath,
                                      operation: path,
                                      jsonObject: nil)
            }
            if result == .aborted {
                return .aborted
            }
            return .done
        }

        let evalHit = jsonElement[effectiveIndex] ?? JsonElement.null

        if isLeaf() {
            let result = Hitch.appending(hitch: currentPath, index: arrayIndex) {
                evaluationContext.add(path: currentPath,
                                      operation: path,
                                      jsonElement: evalHit)
            }
            if result == .aborted {
                return .aborted
            }
            return .done
        } else if let next = next {
            return Hitch.appending(hitch: currentPath, index: arrayIndex) {
                next.evaluate(currentPath: currentPath,
                              parentPath: path,
                              jsonElement: evalHit,
                              evaluationContext: evaluationContext)
            }
        }

        return .done
    }

    @inlinable
    func handle(properties: [Hitch],
                currentPath: Hitch,
                jsonElement: JsonElement,
                evaluationContext: EvaluationContext) -> EvaluationStatus {

        if properties.count == 1 {
            let property = properties[0]
            let path = nullPath()

            let propertyVal = read(property: property,
                                   jsonElement: jsonElement,
                                   evaluationContext: evaluationContext)
            if propertyVal == nil {
                // [From original source] Conditions below heavily depend on current token type (and its logic) and are not "universal",
                // so this code is quite dangerous (I'd rather rewrite it & move to PropertyPathToken and implemented
                // WildcardPathToken as a dynamic multi prop case of PropertyPathToken).
                // Better safe than sorry.

                if isLeaf() {
                    if jsonElement.type == .dictionary,
                       jsonElement.contains(key: property) {
                        let result = Hitch.appending(hitch: currentPath,
                                                     property: property,
                                                     wrap: .singleQuote) {
                            evaluationContext.add(path: currentPath,
                                                     operation: path,
                                                     jsonObject: NSNull())
                        }
                        if result == .aborted {
                            return .aborted
                        }
                    } else {
                        let result = Hitch.appending(hitch: currentPath,
                                                     property: property,
                                                     wrap: .singleQuote) {
                            evaluationContext.add(path: currentPath,
                                                     operation: path,
                                                     jsonObject: nil)
                        }
                        if result == .aborted {
                            return .aborted
                        }
                    }
                    return .done
                } else {
                    if (isUpstreamDefinite() && isTokenDefinite()) == false {
                        return .done
                    }
                    return .aborted
                }
            }

            if let next = next {
                let result = Hitch.appending(hitch: currentPath,
                                             property: property,
                                             wrap: .singleQuote) {
                    next.evaluate(currentPath: currentPath,
                                               parentPath: path,
                                               jsonElement: propertyVal ?? JsonElement.null,
                                               evaluationContext: evaluationContext)
                }
                if result != .done {
                    return result
                }
            } else {
                let result = Hitch.appending(hitch: currentPath,
                                             property: property,
                                             wrap: .singleQuote) {
                    evaluationContext.add(path: currentPath,
                                          operation: path,
                                          jsonElement: propertyVal ?? JsonElement.null)
                }
                if result == .aborted {
                    return .aborted
                }
            }
        } else {
            fatalError("not allowed to merge")
        }

        return .done
    }

    @inlinable
    func has(property: Hitch,
             jsonElement: JsonElement,
             evaluationContext: EvaluationContext) -> Bool {
        return read(property: property,
                    jsonElement: jsonElement,
                    evaluationContext: evaluationContext) != nil
    }

    @inlinable
    func read(property: Hitch,
              jsonElement: JsonElement,
              evaluationContext: EvaluationContext) -> JsonElement? {
        if jsonElement.type == .dictionary {
            return jsonElement[property] ?? nil
        }
        if jsonElement.type == .array {
            guard let index = property.toInt() else { return nil }
            guard index >= 0 && index < jsonElement.count else { return nil }
            return jsonElement[index]
        }
        return nil
    }
}
