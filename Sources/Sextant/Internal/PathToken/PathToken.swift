import Foundation
import Hitch

class PathToken: CustomStringConvertible {
    weak var prev: PathToken?
    var next: PathToken?

    @inlinable
    func checkArray(currentPath: Hitch,
                    jsonObject: JsonAny,
                    evaluationContext: EvaluationContext) -> ArrayPathCheck {
        guard let jsonObject = jsonObject else {
            if isUpstreamDefinite() == false {
                return .skip
            }
            return .error("The path \(currentPath) is null")
        }

        if jsonObject is JsonArray {
            return .handle
        }

        if isUpstreamDefinite() == false {
            return .skip
        }

        return .error("Filter: \(self) can only be applied to arrays. Current context is: \(jsonObject)")
    }

    @inlinable
    func handle(arrayIndex: Int,
                currentPath: Hitch,
                jsonObject: JsonArray,
                evaluationContext: EvaluationContext) -> EvaluationStatus {

        let evalPath = Hitch.make(path: currentPath, index: arrayIndex)
        let path = nullPath()

        let effectiveIndex = arrayIndex < 0 ? jsonObject.count + arrayIndex : arrayIndex

        guard effectiveIndex >= 0 && effectiveIndex < jsonObject.count else { return .done }

        let evalHit = jsonObject[effectiveIndex]

        if isLeaf() {
            if evaluationContext.add(path: evalPath,
                                     operation: path,
                                     jsonObject: evalHit) == .aborted {
                return .aborted
            }
            return .done
        } else if let next = next {
            return next.evaluate(currentPath: evalPath,
                                 parentPath: path,
                                 jsonObject: evalHit,
                                 evaluationContext: evaluationContext)
        }

        return .done
    }

    @inlinable
    func handle(properties: [Hitch],
                currentPath: Hitch,
                jsonObject: JsonAny,
                evaluationContext: EvaluationContext) -> EvaluationStatus {

        if properties.count == 1 {
            let property = properties[0]
            let evalPath = Hitch.make(path: currentPath,
                                      property: property,
                                      wrap: .singleQuote)

            let path = nullPath()

            let propertyVal = read(property: property,
                                   jsonObject: jsonObject,
                                   evaluationContext: evaluationContext)
            if propertyVal == nil {
                // [From original source] Conditions below heavily depend on current token type (and its logic) and are not "universal",
                // so this code is quite dangerous (I'd rather rewrite it & move to PropertyPathToken and implemented
                // WildcardPathToken as a dynamic multi prop case of PropertyPathToken).
                // Better safe than sorry.

                if isLeaf() {
                    if let jsonObject = jsonObject as? JsonDictionary,
                       jsonObject.keys.contains(property.description) {
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
                    return .error("Missing property in path \(evalPath)")
                }
            }

            if let next = next {
                let result = next.evaluate(currentPath: evalPath,
                                           parentPath: path,
                                           jsonObject: propertyVal,
                                           evaluationContext: evaluationContext)
                if result != .done {
                    return result
                }
            } else {
                if evaluationContext.add(path: evalPath, operation: path, jsonObject: propertyVal) == .aborted {
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
             jsonObject: JsonAny,
             evaluationContext: EvaluationContext) -> Bool {
        return read(property: property,
                    jsonObject: jsonObject,
                    evaluationContext: evaluationContext) != nil
    }

    @inlinable
    func read(property: Hitch,
              jsonObject: JsonAny,
              evaluationContext: EvaluationContext) -> JsonAny {
        if let jsonObject = jsonObject as? JsonDictionary {
            return jsonObject[property.description] ?? nil
        }
        // if let jsonObject = jsonObject as? [Hitch: JsonAny] {
        //    return jsonObject[property] ?? nil
        // }
        if let jsonObject = jsonObject as? JsonArray {
            guard let index = property.toInt() else { return nil }
            guard index >= 0 && index < jsonObject.count else { return nil }
            return jsonObject[index]
        }
        return nil
    }

    @inlinable
    func evaluate(currentPath: Hitch,
                  parentPath: Path,
                  jsonObject: JsonAny,
                  evaluationContext: EvaluationContext) -> EvaluationStatus {
        fatalError("should be overwritten")
    }

    @inlinable
    func isRoot() -> Bool {
        return prev == nil
    }

    @inlinable
    func isLeaf() -> Bool {
        return next == nil
    }

    @inlinable
    func isUpstreamDefinite() -> Bool {
        guard let prev = prev else { return true }
        return prev.isTokenDefinite() && prev.isUpstreamDefinite()
    }

    @inlinable
    func isTokenDefinite() -> Bool {
        fatalError("should be overwritten")
    }

    @inlinable
    func isPathDefinite() -> Bool {
        if let next = next,
           isTokenDefinite() {
            return next.isPathDefinite()
        }
        return isTokenDefinite()
    }

    @inlinable
    func pathFragment() -> String {
        fatalError("should be overwritten")
    }

    @inlinable
    @discardableResult
    func append(tail token: PathToken) -> PathToken {
        next = token
        next?.prev = self
        return token
    }

    @inlinable
    @discardableResult
    func append(token: PathToken) -> PathToken {
        return append(tail: token)
    }

    @inlinable
    var description: String {
        if let next = next {
            return pathFragment() + next.description
        }
        return pathFragment()
    }
}
