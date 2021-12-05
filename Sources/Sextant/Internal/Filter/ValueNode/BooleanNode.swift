import Foundation
import Hitch

fileprivate let trueHitch = Hitch("true")
fileprivate let falseHitch = Hitch("false")
fileprivate let typeHitch = Hitch("bool")

class BooleanNode: ValueNode {
    let value: Bool
    
    init(value: Bool) {
        self.value = value
    }
    
    init(hitch: Hitch) {
        self.value = hitch.lowercase() == trueHitch
    }
    
    override var description: String {
        if value {
            return "true"
        }
        return "false"
    }
    
    override var literalValue: Hitch? {
        if value {
            return trueHitch
        }
        return falseHitch
    }
    
    override var typeName: Hitch {
        return typeHitch
    }
}
