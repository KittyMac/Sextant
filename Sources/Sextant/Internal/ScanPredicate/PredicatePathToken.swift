import Foundation
import Hitch
import Spanker

class PredicatePathToken: PathToken {

    var predicates: [Predicate]

    init(predicate: Predicate) {
        self.predicates = [predicate]
    }

    init(predicates: [Predicate]) {
        self.predicates = predicates
    }

    func accept(jsonObject: JsonAny,
                rootJsonObject: JsonAny,
                evaluationContext: EvaluationContext) -> Bool {
        let predicateContext = PredicateContext(jsonObject: jsonObject,
                                                rootJsonObject: rootJsonObject,
                                                pathCache: evaluationContext.evaluationCache)

        for predicate in predicates {
            let result = predicate.apply(predicateContext: predicateContext)
            if result != .true {
                return false
            }
        }
        return true
    }

    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        if let jsonObject = jsonObject as? JsonDictionary {
            if accept(jsonObject: jsonObject,
                      rootJsonObject: evaluationContext.rootJsonObject,
                      evaluationContext: evaluationContext) {
                let op = nullPath()

                if let next = next {
                    let result = next.evaluate(currentPath: currentPath,
                                               parentPath: op,
                                               jsonObject: jsonObject,
                                               evaluationContext: evaluationContext)
                    if result != .done {
                        return result
                    }
                } else {
                    return evaluationContext.add(path: currentPath,
                                                 operation: op,
                                                 jsonObject: jsonObject)
                }
            }
        } else if let array = jsonObject as? JsonArray {
            for idx in 0..<array.count {
                let idxObject = array[idx]
                if accept(jsonObject: idxObject,
                          rootJsonObject: evaluationContext.rootJsonObject,
                          evaluationContext: evaluationContext) {
                    let result = handle(arrayIndex: idx,
                                        currentPath: currentPath,
                                        jsonObject: array,
                                        evaluationContext: evaluationContext)
                    if result != .done {
                        return result
                    }
                }
            }
        } else {
            if isUpstreamDefinite() {
                return .error("Filter: \(description) can not be applied to primitives. Current context is: \(jsonObject ?? "nil")")
            }
        }

        return .done
    }

    func accept(jsonElement: JsonElement,
                rootJsonElement: JsonElement,
                evaluationContext: EvaluationContext) -> Bool {
        let predicateContext = PredicateContext(jsonElement: jsonElement,
                                                rootJsonElement: rootJsonElement,
                                                pathCache: evaluationContext.evaluationCache)

        for predicate in predicates {
            let result = predicate.apply(predicateContext: predicateContext)
            if result != .true {
                return false
            }
        }
        return true
    }

    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonElement: JsonElement,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        if jsonElement.type == .dictionary {
            if accept(jsonElement: jsonElement,
                      rootJsonElement: evaluationContext.rootJsonElement,
                      evaluationContext: evaluationContext) {
                let op = nullPath()

                if let next = next {
                    let result = next.evaluate(currentPath: currentPath,
                                               parentPath: op,
                                               jsonElement: jsonElement,
                                               evaluationContext: evaluationContext)
                    if result != .done {
                        return result
                    }
                } else {
                    return evaluationContext.add(path: currentPath,
                                                 operation: op,
                                                 jsonElement: jsonElement)
                }
            }
        } else if jsonElement.type == .array {
            var idx = 0
            for idxElement in jsonElement.valueArray {
                if accept(jsonElement: idxElement,
                          rootJsonElement: evaluationContext.rootJsonElement,
                          evaluationContext: evaluationContext) {
                    let result = handle(arrayIndex: idx,
                                        currentPath: currentPath,
                                        jsonElement: jsonElement,
                                        evaluationContext: evaluationContext)
                    if result != .done {
                        return result
                    }
                }
                idx += 1
            }
        } else {
            if isUpstreamDefinite() {
                return .error("Filter: \(description) can not be applied to primitives. Current context is: \(jsonElement)")
            }
        }

        return .done
    }

    override func isTokenDefinite() -> Bool {
        return false
    }

    override func pathFragment() -> String {
        let writer = Hitch()
        writer.append(UInt8.openBrace)
        for idx in 0..<predicates.count {
            if idx != 0 {
                writer.append(UInt8.comma)
            }
            writer.append(UInt8.questionMark)
        }
        writer.append(UInt8.closeBrace)
        return writer.description
    }
}
