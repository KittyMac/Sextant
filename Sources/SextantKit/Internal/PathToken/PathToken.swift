import Foundation
import HitchKit
import SpankerKit

class PathToken: CustomStringConvertible {
    weak var prev: PathToken?
    var next: PathToken?

    @inlinable @inline(__always)
    func checkArray(currentPath: Hitch,
                    jsonObject: JsonAny,
                    evaluationContext: EvaluationContext) -> ArrayPathCheck {
        guard let jsonObject = jsonObject else {
            if isUpstreamDefinite() == false {
                return .skip
            }
            return .skip
        }

        if jsonObject is JsonArray {
            return .handle
        }

        if isUpstreamDefinite() == false {
            return .skip
        }

        return .skip
    }

    @inlinable @inline(__always)
    func handle(arrayIndex: Int,
                currentPath: Hitch,
                jsonObject: JsonArray,
                evaluationContext: EvaluationContext) -> EvaluationStatus {

        let effectiveIndex = arrayIndex < 0 ? jsonObject.count + arrayIndex : arrayIndex

        guard effectiveIndex >= 0 && effectiveIndex < jsonObject.count else {
            let result = Hitch.appending(hitch: currentPath, index: arrayIndex) {
                evaluationContext.add(path: currentPath,
                                      operation: NullPath.shared,
                                      jsonObject: nil)
            }
            if result == .aborted {
                return .aborted
            }
            return .done
        }

        let evalHit = jsonObject[effectiveIndex]

        let path = evaluationContext.options.contains(.updateOperation) ?
            newPath(array: jsonObject, index: effectiveIndex, item: evalHit) :
            NullPath.shared

        if isLeaf() {
            let result = Hitch.appending(hitch: currentPath, index: arrayIndex) {
                evaluationContext.add(path: currentPath,
                                      operation: path,
                                      jsonObject: evalHit)
            }
            if result == .aborted {
                return .aborted
            }
            return .done
        } else if let next = next {
            return Hitch.appending(hitch: currentPath, index: arrayIndex) {
                next.evaluate(currentPath: currentPath,
                              parentPath: path,
                              jsonObject: evalHit,
                              evaluationContext: evaluationContext)
            }
        }

        return .done
    }

    @inlinable @inline(__always)
    func handle(property: Hitch,
                currentPath: Hitch,
                jsonObject: JsonAny,
                evaluationContext: EvaluationContext) -> EvaluationStatus {

        let path = evaluationContext.options.contains(.updateOperation) ?
            newPath(any: jsonObject, property: property) :
            NullPath.shared

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
                              jsonObject: propertyVal,
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
                                      jsonObject: propertyVal)
            }
            if result == .aborted {
                return .aborted
            }
        }

        return .done
    }

    @inlinable @inline(__always)
    func has(property: Hitch,
             jsonObject: JsonAny,
             evaluationContext: EvaluationContext) -> Bool {
        return read(property: property,
                    jsonObject: jsonObject,
                    evaluationContext: evaluationContext) != nil
    }

    @inlinable @inline(__always)
    func read(property: Hitch,
              jsonObject: JsonAny,
              evaluationContext: EvaluationContext) -> JsonAny {
        if let jsonObject = jsonObject as? JsonDictionary {
            return jsonObject[property.description] ?? nil
        }
        if let jsonObject = jsonObject as? JsonArray {
            guard let index = property.toInt() else { return nil }
            guard index >= 0 && index < jsonObject.count else { return nil }
            return jsonObject[index]
        }
        return nil
    }

    @inlinable @inline(__always)
    func evaluate(currentPath: Hitch,
                  parentPath: Path,
                  jsonObject: JsonAny,
                  evaluationContext: EvaluationContext) -> EvaluationStatus {
        fatalError("should be overwritten")
    }

    @inlinable @inline(__always)
    func evaluate(currentPath: Hitch,
                  parentPath: Path,
                  jsonElement: JsonElement,
                  evaluationContext: EvaluationContext) -> EvaluationStatus {
        fatalError("should be overwritten")
    }

    @inlinable @inline(__always)
    func isRoot() -> Bool {
        return prev == nil
    }

    @inlinable @inline(__always)
    func isLeaf() -> Bool {
        return next == nil
    }

    @inlinable @inline(__always)
    func isUpstreamDefinite() -> Bool {
        guard let prev = prev else { return true }
        return prev.isTokenDefinite() && prev.isUpstreamDefinite()
    }

    @inlinable @inline(__always)
    func isTokenDefinite() -> Bool {
        fatalError("should be overwritten")
    }

    @inlinable @inline(__always)
    func isPathDefinite() -> Bool {
        if let next = next,
           isTokenDefinite() {
            return next.isPathDefinite()
        }
        return isTokenDefinite()
    }

    @inlinable @inline(__always)
    func pathFragment() -> String {
        fatalError("should be overwritten")
    }

    @inlinable @inline(__always)
    @discardableResult
    func append(tail token: PathToken) -> PathToken {
        next = token
        next?.prev = self
        return token
    }

    @inlinable @inline(__always)
    @discardableResult
    func append(token: PathToken) -> PathToken {
        return append(tail: token)
    }

    @inlinable @inline(__always)
    var description: String {
        if let next = next {
            return pathFragment() + next.description
        }
        return pathFragment()
    }
}
