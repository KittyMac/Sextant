import Foundation
import Hitch

fileprivate let typeHitch = Hitch("null")

struct NullNode: ValueNode {
    
    static func == (lhs: NullNode, rhs: NullNode) -> Bool {
        return true
    }
    
    var description: String {
        return "null"
    }
        
    var typeName: Hitch {
        return typeHitch
    }
    
    var literalValue: Hitch? {
        nil
    }
    
    var numericValue: Double? {
        return nil
    }
}
