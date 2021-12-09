import Foundation
import Hitch

fileprivate typealias EvaluatorBlock = (_ left: ValueNode?,
                                        _ right: ValueNode?,
                                        _ context: PredicateContext) -> EvaluatorResult

enum EvaluatorResult {
    case `true`
    case `false`
    case error
    
    func inverse() -> EvaluatorResult {
        if self == .true {
            return .false
        }
        if self == .false {
            return .true
        }
        return .error
    }
}

class Evaluator {
    
    fileprivate let block: EvaluatorBlock
    
    init?(relationalOperator: RelationalOperator) {
        switch relationalOperator {
        case .GTE:
            block = evaluateGTE
        case .LTE:
            block = evaluateLTE
        case .EQ:
            block = evaluateEQ
        case .TSEQ:
            block = evaluateTSEQ
        case .NE:
            block = evaluateNE
        case .TSNE:
            block = evaluateTSNE
        case .LT:
            block = evaluateLT
        case .GT:
            block = evaluateGT
        case .REGEX:
            block = evaluateREGEX
        case .NIN:
            block = evaluateNIN
        case .IN:
            block = evaluateIN
        case .CONTAINS:
            block = evaluateCONTAINS
        case .ALL:
            block = evaluateALL
        case .SIZE:
            block = evaluateSIZE
        case .EXISTS:
            block = evaluateEXISTS
        case .TYPE:
            block = evaluateTYPE
        case .EMPTY:
            block = evaluateEMPTY
        case .SUBSETOF:
            block = evaluateSUBSETOF
        case .ANYOF:
            block = evaluateANYOF
        case .NONEOF:
            block = evaluateNONEOF
        }
    }
    
    func evaluate(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
        block(left, right, context)
    }
}

fileprivate func evaluateToBeImplemented(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    fatalError("TO BE IMPLEMENTED")
}

fileprivate func evaluateGTE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .greaterThan || result == .same {
        return .true
    }
    return .false
}

fileprivate func evaluateLTE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .lessThan || result == .same {
        return .true
    }
    return .false
}

fileprivate func evaluateEQ(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .same {
        return .true
    }
    return .false
}

fileprivate func evaluateTSEQ(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .same && left.typeName == right.typeName {
        return .true
    }
    return .false
}

fileprivate func evaluateNE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    if evaluateEQ(left: left, right: right, context: context) == .true {
        return .false
    }
    return .true
}

fileprivate func evaluateTSNE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    if evaluateTSEQ(left: left, right: right, context: context) == .true {
        return .false
    }
    return .true
}

fileprivate func evaluateGT(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .greaterThan {
        return .true
    }
    return .false
}

fileprivate func evaluateLT(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .lessThan {
        return .true
    }
    return .false
}

fileprivate func evaluateREGEX(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    var regex: NSRegularExpression? = nil
    var hitch: Hitch? = nil
    
    if let left = left as? PatternNode {
        regex = left.regex
        hitch = right?.literalValue
    } else if let right = right as? PatternNode {
        regex = right.regex
        hitch = left?.literalValue
    }
    
    guard let regex = regex else {
        return .error
    }
    
    guard let hitch = hitch else {
        return .false
    }
    
    let valueAsString = hitch.description
    let matches = regex.numberOfMatches(in: valueAsString,
                                        options: [],
                                        range: NSMakeRange(0, valueAsString.count))
    
    if matches > 0 {
        return .true
    }
    return .false
}

fileprivate func evaluateEXISTS(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left as? BooleanNode else {
        error("Failed to evaluate EXISTS expression")
        return .error
    }
    guard let right = right as? BooleanNode else {
        error("Failed to evaluate EXISTS expression")
        return .error
    }
    
    if left == right {
        return .true
    }
    return .false
}

fileprivate func evaluateSIZE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let right = right as? NumberNode else {
        return .false
    }
    guard let expectedSize = right.numericValue else { return .false }
    
    if let left = left as? StringNode {
        if left.literalValue?.count == Int(expectedSize) {
            return .true
        }
        return .false
    }
    if let left = left as? JsonNode {
        if let array = left.json as? JsonArray,
           array.count == Int(expectedSize) {
            return .true
        }
        if let dict = left.json as? JsonDictionary,
           dict.count == Int(expectedSize) {
            return .true
        }
        return .false
    }
    return .false
}

fileprivate func evaluateIN(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let right = right as? JsonNode else { return .false }
    guard let rightArray = right.json as? JsonArray else { return .false }
    guard let left = left else { return .false }
    for item in rightArray where left.equals(to: item) == .same {
        return .true
    }
    return .false
}

fileprivate func evaluateNIN(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return evaluateIN(left: left, right: right, context: context).inverse()
}

fileprivate func evaluateCONTAINS(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    if let left = left as? StringNode,
       let right = right as? StringNode {
        guard let left = left.literalValue else { return .false }
        guard let right = right.literalValue else { return .false }
        if left.contains(right) {
            return .true
        }
        return .false
    }
    return evaluateIN(left: left, right: right, context: context)
}

fileprivate func evaluateALL(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left as? JsonNode else { return .false }
    guard let right = right as? JsonNode else { return .false }
    guard let left = left.json as? JsonArray else { return .false }
    guard let right = right.json as? JsonArray else { return .false }
    
    for rightObject in right {
        var hasValue = false
        for leftObject in left where anyEquals(rightObject, leftObject) {
            hasValue = true
        }
        if hasValue == false {
            return .false
        }
    }
    return .true
}

fileprivate func evaluateTYPE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    if type(of: left) == type(of: right) {
        return .true
    }
    return .false
}

fileprivate func evaluateSUBSETOF(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left as? JsonNode else { return .false }
    guard let right = right as? JsonNode else { return .false }
    guard let left = left.json as? JsonArray else { return .false }
    guard let right = right.json as? JsonArray else { return .false }
    
    for leftObject in left {
        for rightObject in right where anyEquals(rightObject, leftObject) == false {
            return .false
        }
    }
    return .true
}

fileprivate func evaluateANYOF(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left as? JsonNode else { return .false }
    guard let right = right as? JsonNode else { return .false }
    guard let left = left.json as? JsonArray else { return .false }
    guard let right = right.json as? JsonArray else { return .false }
    
    for leftObject in left {
        for rightObject in right where anyEquals(rightObject, leftObject) {
            return .true
        }
    }
    return .false
}

fileprivate func evaluateNONEOF(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return evaluateANYOF(left: left, right: right, context: context).inverse()
}

fileprivate func evaluateEMPTY(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let right = right as? BooleanNode else { return .false }
    
    if right.value {
        return evaluateSIZE(left: left, right: NumberNode.zero, context: context)
    }
    return evaluateSIZE(left: left, right: NumberNode.zero, context: context).inverse()
}
