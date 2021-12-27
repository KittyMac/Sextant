import Foundation
import Hitch
import Spanker

extension PathToken {

    @inlinable
    func checkArray(currentPath: Hitch,
                    jsonElement: JsonElement,
                    evaluationContext: EvaluationContext) -> ArrayPathCheck {
        guard jsonElement.type != .null else {
            if isUpstreamDefinite() == false {
                return .skip
            }
            return .error("The path \(currentPath) is null")
        }

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

        let evalPath = Hitch.make(path: currentPath, index: arrayIndex)
        let path = nullPath()

        let effectiveIndex = arrayIndex < 0 ? jsonElement.count + arrayIndex : arrayIndex

        guard effectiveIndex >= 0 && effectiveIndex < jsonElement.count else {
            if evaluationContext.add(path: evalPath,
                                     operation: path,
                                     jsonObject: nil) == .aborted {
                return .aborted
            }
            return .done
        }

        let evalHit = jsonElement[effectiveIndex] ?? JsonElement.null

        if isLeaf() {
            if evaluationContext.add(path: evalPath,
                                     operation: path,
                                     jsonElement: evalHit) == .aborted {
                return .aborted
            }
            return .done
        } else if let next = next {
            return next.evaluate(currentPath: evalPath,
                                 parentPath: path,
                                 jsonElement: evalHit,
                                 evaluationContext: evaluationContext)
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
            let evalPath = Hitch.make(path: currentPath,
                                      property: property,
                                      wrap: .singleQuote)

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
                        if evaluationContext.add(path: evalPath,
                                                 operation: path,
                                                 jsonObject: NSNull()) == .aborted {
                            return .aborted
                        }
                    } else {
                        if evaluationContext.add(path: evalPath,
                                                 operation: path,
                                                 jsonObject: nil) == .aborted {
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
                let result = next.evaluate(currentPath: evalPath,
                                           parentPath: path,
                                           jsonElement: propertyVal ?? JsonElement.null,
                                           evaluationContext: evaluationContext)
                if result != .done {
                    return result
                }
            } else {
                if evaluationContext.add(path: evalPath, operation: path, jsonElement: propertyVal ?? JsonElement.null) == .aborted {
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
