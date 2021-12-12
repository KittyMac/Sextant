import Foundation
import Hitch

private typealias EvaluatorBlock = (_ left: ValueNode?,
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

private func evaluateGTE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return (evaluateEQ(left: left, right: right, context: context) == .true || evaluateGT(left: left, right: right, context: context) == .true) ? .true : .false
}

private func evaluateLTE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return (evaluateEQ(left: left, right: right, context: context) == .true || evaluateLT(left: left, right: right, context: context) == .true) ? .true : .false
}

private func evaluateEQ(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .same {
        return .true
    }
    return .false
}

private func evaluateTSEQ(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return (evaluateEQ(left: left, right: right, context: context) == .true && evaluateTYPE(left: left, right: right, context: context) == .true) ? .true : .false
}

private func evaluateNE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return evaluateEQ(left: left, right: right, context: context).inverse()
}

private func evaluateTSNE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return evaluateTSEQ(left: left, right: right, context: context).inverse()
}

private func evaluateGT(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .greaterThan {
        return .true
    }
    return .false
}

private func evaluateLT(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = left else { return .false }
    guard let right = right else { return .false }
    let result = left.compare(to: right)
    if result == .lessThan {
        return .true
    }
    return .false
}

private func evaluateREGEX(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    var regex0: NSRegularExpression?
    var hitch0: Hitch?

    if let left = left as? PatternNode {
        regex0 = left.regex
        hitch0 = right?.literalValue
    } else if let right = right as? PatternNode {
        regex0 = right.regex
        hitch0 = left?.literalValue
    }

    guard let regex = regex0 else { return .error }
    guard let hitch = hitch0 else { return .false }

    let valueAsString = hitch.description
    let matches = regex.numberOfMatches(in: valueAsString,
                                        options: [],
                                        range: NSRange(location: 0, length: valueAsString.count))

    if matches > 0 {
        return .true
    }
    return .false
}

private func evaluateEXISTS(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
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

private func evaluateSIZE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
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

private func evaluateIN(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let right = right as? JsonNode else { return .false }
    guard let rightArray = right.json as? JsonArray else { return .false }
    guard let left = left else { return .false }
    for item in rightArray where left.equals(to: item) == .same {
        return .true
    }
    return .false
}

private func evaluateNIN(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return evaluateIN(left: left, right: right, context: context).inverse()
}

private func evaluateCONTAINS(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
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

private func evaluateALL(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = (left as? JsonNode)?.json as? JsonArray else { return .false }
    guard let right = (right as? JsonNode)?.json as? JsonArray else { return .false }

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

private func evaluateTYPE(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    if let right = right as? StringNode {
        return left?.typeName == right.literalValue ? .true : .false
    }
    if left?.typeName == right?.typeName {
        return .true
    }
    return .false
}

private func evaluateSUBSETOF(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = (left as? JsonNode)?.json as? JsonArray else { return .false }
    guard let right = (right as? JsonNode)?.json as? JsonArray else { return .false }

    var count = 0
    for leftObject in left {
        for rightObject in right where anyEquals(rightObject, leftObject) == true {
            count += 1
            break
        }
    }

    if count == left.count {
        return .true
    }
    return .false
}

private func evaluateANYOF(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let left = (left as? JsonNode)?.json as? JsonArray else { return .false }
    guard let right = (right as? JsonNode)?.json as? JsonArray else { return .false }

    for leftObject in left {
        for rightObject in right where anyEquals(rightObject, leftObject) {
            return .true
        }
    }
    return .false
}

private func evaluateNONEOF(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    return evaluateANYOF(left: left, right: right, context: context).inverse()
}

private func evaluateEMPTY(left: ValueNode?, right: ValueNode?, context: PredicateContext) -> EvaluatorResult {
    guard let right = right as? BooleanNode else { return .false }
    if left == nil || left is NullNode {
        return .false
    }

    if right.value {
        return evaluateSIZE(left: left, right: NumberNode.zero, context: context)
    }
    return evaluateSIZE(left: left, right: NumberNode.zero, context: context).inverse()
}
