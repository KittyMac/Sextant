import Foundation
import Hitch

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

/*
- (SMJEvaluationStatus)evaluateWithCurrentPath:(NSString *)currentPath parentPathRef:(SMJPathRef *)parent jsonObject:(id)jsonObject evaluationContext:(SMJEvaluationContextImpl *)context error:(NSError **)error
{
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        
    }
    else if ([jsonObject isKindOfClass:[NSArray class]])
    {
        
    }
    else
    {
        if ([self isUpstreamDefinite])
        {
            SMSetError(error, 1, @"Filter: %@ can not be applied to primitives. Current context is: %@", [self stringValue], jsonObject);
            return SMJEvaluationStatusError;
        }
    }
             
     return SMJEvaluationStatusDone;
}

*/
