import Foundation
import Hitch

private let boolHitch = Hitch("bool")
private let jsonHitch = Hitch("json")
private let numberHitch = Hitch("number")
private let pathHitch = Hitch("path")
private let patternHitch = Hitch("pattern")
private let stringHitch = Hitch("string")

enum ValueNodeType {
    case boolean
    case json
    case null
    case number
    case path
    case pattern
    case string

    func literalValue() -> Hitch {
        switch self {
        case .boolean: return boolHitch
        case .json: return jsonHitch
        case .null: return nullHitch
        case .number: return numberHitch
        case .path: return pathHitch
        case .pattern: return patternHitch
        case .string: return stringHitch
        }
    }
}

enum ValueComparisonResult {
    case same
    case differ
    case greaterThan
    case lessThan
    case error
}

protocol ValueNode: CustomStringConvertible {
    var typeName: ValueNodeType { get }

    func stringValue() -> String?

    var literalValue: Hitch? { get }
    var numericValue: Double? { get }

    func getJsonArray() -> JsonArray?
    func getJsonDictionary() -> JsonDictionary?
    func getRegex() -> NSRegularExpression?

    func evaluate(context: PredicateContext, options: EvaluationOptions) -> ValueNode?
    func copyForExistsCheck() -> ValueNode
    func shouldExists() -> Bool
}

extension ValueNode {
    func getJsonArray() -> JsonArray? {
        return nil
    }
    func getJsonDictionary() -> JsonDictionary? {
        return nil
    }
    func getRegex() -> NSRegularExpression? {
        return nil
    }

    func evaluate(context: PredicateContext, options: EvaluationOptions) -> ValueNode? {
        return nil
    }
    func copyForExistsCheck() -> ValueNode {
        return self
    }
    func shouldExists() -> Bool {
        return false
    }

    func equals(to other: JsonAny) -> ValueComparisonResult {
        if (other == nil || other is NSNull) && self is NullNode {
            return .same
        }
        guard let other = other else { return .differ }

        if let other = other as? ValueNode {
            return compare(to: other)
        }

        if let literalValue = literalValue {
            if let other = other as? String,
               literalValue.description == other {
                return .same
            }
            if let other = other as? Hitch,
               literalValue.description == other {
                return .same
            }
            if let other = other as? HalfHitch,
               literalValue.description == other {
                return .same
            }
            if let other = other as? CustomStringConvertible,
               literalValue.description == other.description {
                return .same
            }
        }

        return .differ
    }

    func compare(to other: ValueNode) -> ValueComparisonResult {

        if let number1 = numericValue,
           let number2 = other.numericValue {
            if number1 == number2 {
                return .same
            } else if number1 < number2 {
                return .lessThan
            } else {
                return .greaterThan
            }
        }

        if let hitch1 = literalValue,
           let hitch2 = other.literalValue {
            let d = hitch1.compare(other: hitch2)
            if d == 0 {
                return .same
            } else if d < 0 {
                return .lessThan
            } else {
                return .greaterThan
            }
        }

        if self.literalValue == other.literalValue {
            return .same
        }

        return .differ
    }

    @inlinable @inline(__always)
    func equal(to other: ValueNode) -> Bool {

        if let number1 = numericValue,
           let number2 = other.numericValue {
            return number1 == number2
        }

        if let hitch1 = literalValue,
           let hitch2 = other.literalValue {
            return hitch1 == hitch2
        }

        if self.literalValue == other.literalValue {
            return true
        }

        return false
    }
}
