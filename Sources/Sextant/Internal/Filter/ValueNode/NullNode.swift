import Foundation
import Hitch

fileprivate let typeHitch = Hitch("null")

class NullNode: ValueNode {
    static func == (lhs: NullNode, rhs: NullNode) -> Bool {
        return true
    }
    
    override var description: String {
        return "null"
    }
        
    override var typeName: Hitch {
        return typeHitch
    }
}
