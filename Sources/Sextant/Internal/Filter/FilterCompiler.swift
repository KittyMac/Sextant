import Foundation
import Hitch

private let kDocContextChar = UInt8.dollarSign
private let kEvalContextChar = UInt8.atMark

private let kOpenSquareBracketChar = UInt8.openBrace
private let kCloseSquareBracketChar = UInt8.closeBrace
private let kOpenParenthesisChar = UInt8.parenOpen
private let kCloseParenthesisChar = UInt8.parenClose
private let kOpenObjectChar = UInt8.openBracket
private let kCloseObjectChar = UInt8.closeBracket
private let kOpenArrayChar = UInt8.openBrace
private let kCloseArrayChar = UInt8.closeBrace

private let kSingleQuoteChar = UInt8.singleQuote
private let kDoubleQuoteChar = UInt8.doubleQuote

private let kSpaceChar = UInt8.space
private let kPeriodChar = UInt8.dot

private let kAndChar = UInt8.ampersand
private let kOrChar = UInt8.pipe

private let kMinusChar = UInt8.minus
private let kLessThanChar = UInt8.lessThan
private let kGreaterThanChar = UInt8.greaterThan
private let kEqualChar = UInt8.equal
private let kTildeChar = UInt8.tilde
private let kTrueChar = UInt8.t
private let kFalseChar = UInt8.f
private let kNullChar = UInt8.n
private let kNotChar = UInt8.bang
private let kPatternChar = UInt8.forwardSlash
private let kIgnoreCaseChar = UInt8.i

private let nullHitch = Hitch("null")
private let trueHitch = Hitch("true")
private let falseHitch = Hitch("false")

final class FilterCompiler {
    var filter: CharacterIndex

    init?(filter filterString: Hitch) {
        filter = CharacterIndex(query: filterString)
        filter.trim()

        guard filter.current() == .openBrace && filter.last() == .closeBrace else {
            error("Filter must start with '[' and end with ']'. \(filter)")
            return nil
        }

        filter.advance(1)
        filter.removeFromEnd(1)
        filter.trim()

        guard filter.current() == .questionMark else {
            error("Filter must start with '[?' and end with ']'. \(filter)")
            return nil
        }

        filter.advance(1)
        filter.trim()

        guard filter.current() == .parenOpen || filter.last() == .parenClose else {
            error("Filter must start with '[?(' and end with ')]'. \(filter)")
            return nil
        }
    }

    class func compile(filter: Hitch) -> Predicate? {
        guard let predicate = FilterCompiler(filter: filter)?.compile() else { return nil }
        return CompiledFilter(predicate: predicate)
    }

    func compile() -> Predicate? {
        guard let result = readLogicalOR() else { return nil }

        filter.skipBlanks()

        if filter.inBounds() {
            error("Expected end of filter expression instead of: \(filter)")
            return nil
        }

        return result
    }

    func readLogicalOR() -> ExpressionNode? {
        var ops = [ExpressionNode]()

        guard let logicalAND = readLogicalAND() else { return nil }

        ops.append(logicalAND)

        while true {
            let savepoint = filter.position
            if filter.hasSignificantString(string: kLogicalOperatorOR) == false {
                filter.position = savepoint
                break
            }

            guard let logicalAND = readLogicalANDOperand() else {
                filter.position = savepoint
                break
            }

            ops.append(logicalAND)
        }

        return ops.count == 1 ? ops.first : LogicalExpressionNode.logicalOr(nodes: ops)
    }

    func readLogicalAND() -> ExpressionNode? {
        var ops = [ExpressionNode]()

        guard let logicalAND = readLogicalANDOperand() else { return nil }

        ops.append(logicalAND)

        while true {
            let savepoint = filter.position
            if filter.hasSignificantString(string: kLogicalOperatorAND) == false {
                filter.position = savepoint
                break
            }

            guard let logicalAND = readLogicalANDOperand() else {
                filter.position = savepoint
                break
            }

            ops.append(logicalAND)
        }

        return ops.count == 1 ? ops.first : LogicalExpressionNode.logicalAnd(nodes: ops)
    }

    func readLogicalANDOperand() -> ExpressionNode? {
        let savepoint = filter.skipBlanks().position

        if filter.skipBlanks().current() == kNotChar {
            guard filter.readSignificantCharacter(character: kNotChar) else { return nil }

            switch filter.skipBlanks().current() {
            case kDocContextChar, kEvalContextChar:
                filter.position = savepoint
                break
            default:
                guard let op = readLogicalANDOperand() else { return nil }
                return LogicalExpressionNode.logicalNot(node: op)
            }
        }

        if filter.skipBlanks().current() == kOpenParenthesisChar {
            guard filter.readSignificantCharacter(character: kOpenParenthesisChar) else { return nil }
            guard let op = readLogicalOR() else { return nil }
            guard filter.readSignificantCharacter(character: kCloseParenthesisChar) else { return nil }
            return op
        }

        return readExpression()
    }

    func readExpression() -> RelationalExpressionNode? {
        guard let left = readValueNode() else { return nil }

        let savepoint = filter.position

        let relationalOperator = readRelationalOperator()
        if let relationalOperator = relationalOperator,
           let right = readValueNode() {
            return RelationalExpressionNode(left: left,
                                            relationalOperator: relationalOperator,
                                            right: right)
        }

        filter.position = savepoint

        guard left.typeName == .path else {
            error("path node expected")
            return nil
        }

        return RelationalExpressionNode(left: left.copyForExistsCheck(),
                                        relationalOperator: .EXISTS,
                                        right: left.shouldExists() ? BooleanNode.true : BooleanNode.false)
    }

    func readRelationalOperator() -> RelationalOperator? {
        let begin = filter.skipBlanks().position

        if isRelationalOperatorChar(filter.current()) {
            while filter.inBounds() && isRelationalOperatorChar(filter.current()) {
                filter.advance(1)
            }
        } else {
            while filter.inBounds() && filter.current() != .space {
                filter.advance(1)
            }
        }

        guard let relationalOperator = filter.substring(begin, filter.position) else { return nil }
        return RelationalOperator(hitch: relationalOperator)
    }

    func readValueNode() -> ValueNode? {
        switch filter.skipBlanks().current() {
        case kDocContextChar, kEvalContextChar:
            return readPath()
        case kNotChar:
            filter.advance(1)
            switch filter.skipBlanks().current() {
            case kDocContextChar, kEvalContextChar:
                return readPath()
            default:
                error("Unexpected character '\(kNotChar)'")
                return nil
            }
        default:
            return readLiteral()
        }
    }

    func readLiteral() -> ValueNode? {
        switch filter.skipBlanks().current() {
            case kSingleQuoteChar:
                return readStringLiteral(endChar: kSingleQuoteChar)
            case kDoubleQuoteChar:
                return readStringLiteral(endChar: kDoubleQuoteChar)
            case kTrueChar:
                return readBooleanLiteral()
            case kFalseChar:
                return readBooleanLiteral()
            case kMinusChar:
                return readNumberLiteral()
            case kNullChar:
                return readNullLiteral()
            case kOpenObjectChar:
                return readJsonLiteral()
            case kOpenArrayChar:
                return readJsonLiteral()
            case kPatternChar:
                return readPatternLiteral()
            default:
                return readNumberLiteral()
        }
    }

    func readNullLiteral() -> NullNode? {
        if filter.current() == kNullChar && filter.compareAndAdvance(hitch: nullHitch) {
            return NullNode.null
        }
        error("Expected <null> value")
        return nil
    }

    func readJsonLiteral() -> JsonNode? {
        let begin = filter.position

        let openChar = filter.current()

        if openChar != kOpenArrayChar && openChar != kOpenObjectChar {
            error("internal error")
            return nil
        }

        let closeChar = openChar == kOpenArrayChar ? kCloseArrayChar : kCloseObjectChar

        let closingIndex = filter.indexOfMatchingCloseCharacter(index: filter.position,
                                                                openChar: openChar,
                                                                closeChar: closeChar,
                                                                skipStrings: true,
                                                                skipRegex: false)
        if closingIndex < 0 {
            error("String not closed. Expected \(kSingleQuoteChar) in \(filter)")
            return nil
        }

        filter.position = closingIndex + 1

        guard let json = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }

        return JsonNode(hitch: json)
    }

    func readPatternLiteral() -> PatternNode? {
        let begin = filter.position
        var closingIndex = filter.nextIndexOfUnescapedCharacter(character: kPatternChar)

        guard closingIndex >= 0 else {
            error("Pattern not closed. Expected \(kPatternChar) in \(filter)")
            return nil
        }

        if filter.inBounds(position: closingIndex + 1) {
            let equalSignIndex = filter.nextIndexOfCharacter(character: .equal)
            let endIndex = equalSignIndex >= 0 ? equalSignIndex : filter.nextIndexOfUnescapedCharacter(character: kCloseParenthesisChar)
            if let flags = filter.substring(closingIndex + 1, endIndex) {
                closingIndex += flags.count
            }
        }
        filter.position = closingIndex + 1

        guard let pattern = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }
        return PatternNode(regex: pattern)
    }

    func readStringLiteral(endChar: UInt8) -> StringNode? {
        let begin = filter.position
        let closingSingleQuoteIndex = filter.nextIndexOfUnescapedCharacter(character: endChar)

        guard closingSingleQuoteIndex >= 0 else {
            error("String literal does not have matching quotes. Expected \(endChar) in \(filter)")
            return nil
        }

        filter.position = closingSingleQuoteIndex + 1

        guard let stringLiteral = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }

        return StringNode(hitch: stringLiteral, escape: true)
    }

    func readNumberLiteral() -> NumberNode? {
        let begin = filter.position
        while filter.inBounds() && filter.isNumberCharacter(index: filter.position) {
            filter.advance(1)
        }
        guard let numberLiteral = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }
        return NumberNode(hitch: numberLiteral)
    }

    func readBooleanLiteral() -> BooleanNode? {
        if filter.compareAndAdvance(hitch: trueHitch) {
            return BooleanNode.true
        }
        if filter.compareAndAdvance(hitch: falseHitch) {
            return BooleanNode.false
        }
        error("Expected boolean literal")
        return nil
    }

    func readPath() -> PathNode? {
        let previousSignificantChar = filter.previousSignificantCharacter()
        let begin = filter.position

        filter.advance(1) // skip $ and @

        while filter.inBounds() {
            if filter.current() == .openBrace {
                let closingSquareBracketIndex = filter.indexOfMatchingCloseCharacter(index: filter.position,
                                                                                     openChar: .openBrace,
                                                                                     closeChar: .closeBrace,
                                                                                     skipStrings: true,
                                                                                     skipRegex: false)

                guard closingSquareBracketIndex >= 0 else {
                    error("Square brackets does not match in filter \(filter)")
                    return nil
                }

                filter.position = closingSquareBracketIndex + 1
            }

            let closingFunctionBracket = filter.current() == .parenClose && currentCharIsClosingFunctionBracket(lowerBound: begin)
            let closingLogicalBracket = filter.current() == .parenClose && !closingFunctionBracket

            if filter.inBounds() == false || isRelationalOperatorChar(filter.current()) || filter.current() == .space || closingLogicalBracket {
                break
            }

            filter.advance(1)
        }

        let shouldExists = !(previousSignificantChar == kNotChar)
        guard let pathString = filter.substring(begin, filter.position) else {
            return nil
        }

        return PathNode(path: pathString,
                        existsCheck: false,
                        shouldExists: shouldExists)
    }

    func currentCharIsClosingFunctionBracket(lowerBound: Int) -> Bool {
        if filter.current() != .parenClose {
            return false
        }

        var idx = filter.indexOfPreviousSignificantCharacter()
        if idx == -1 || filter[idx] != .parenOpen {
            return false
        }

        idx -= 1

        while filter.inBounds(position: idx) && idx > lowerBound {
            if filter[idx] == .dot {
                return true
            }

            idx -= 1
        }
        return false
    }

    func isLogicalOperatorChar(_ c: UInt8) -> Bool {
        return c == kAndChar || c == kOrChar
    }

    func isRelationalOperatorChar(_ c: UInt8) -> Bool {
        return c == kLessThanChar || c == kGreaterThanChar || c == kEqualChar || c == kTildeChar || c == kNotChar
    }
}
