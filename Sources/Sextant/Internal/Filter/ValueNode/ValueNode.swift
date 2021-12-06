import Foundation
import Hitch

enum ValueComparisonResult {
    case same
    case differ
    case greaterThan
    case lessThan
    case error
}

protocol ValueNode: CustomStringConvertible {
    var typeName: Hitch { get }
    
    var literalValue: Hitch? { get }
    var numericValue: Double? { get }
}

extension ValueNode {
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
}
