import Foundation
import Hitch

fileprivate let trueHitch = Hitch("true")
fileprivate let falseHitch = Hitch("false")
fileprivate let typeHitch = Hitch("bool")

struct BooleanNode: ValueNode, Equatable {
    static let `true` = BooleanNode(value: true)
    static let `false` = BooleanNode(value: false)
    
    static func == (lhs: BooleanNode, rhs: BooleanNode) -> Bool {
        return lhs.value == rhs.value
    }
    
    let value: Bool
    
    init(value: Bool) {
        self.value = value
    }
    
    init(hitch: Hitch) {
        self.value = hitch.lowercase() == trueHitch
    }
    
    var description: String {
        if value {
            return "true"
        }
        return "false"
    }
    
    var literalValue: Hitch? {
        if value {
            return trueHitch
        }
        return falseHitch
    }
    
    var typeName: Hitch {
        return typeHitch
    }
    
    var numericValue: Double? {
        return value ? 1 : 0
    }
}
