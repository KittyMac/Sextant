import Foundation
import Hitch

fileprivate let typeHitch = Hitch("string")

struct StringNode: ValueNode {
    let value: Hitch
    let useSingleQuote: Bool
        
    init(hitch: Hitch, escape: Bool) {
        var localValue = hitch
        
        if hitch.count > 1 {
            let start = hitch[0]
            let end = hitch[hitch.count - 1]
            
            if start == .singleQuote && end == .singleQuote {
                useSingleQuote = true
                localValue = localValue.substring(1, hitch.count - 1) ?? localValue
            } else if start == .singleQuote && end == .singleQuote {
                useSingleQuote = false
                localValue = localValue.substring(1, hitch.count - 1) ?? localValue
            } else {
                useSingleQuote = true
            }
        } else {
            useSingleQuote = false
        }
        
        if escape {
            self.value = localValue
            self.value.unescape()
        } else {
            self.value = localValue
        }
    }
        
    var description: String {
        if useSingleQuote {
            return "'\(value.escape())'"
        }
        return value.description
    }
    
    var literalValue: Hitch? {
        return value
    }
    
    var numericValue: Double? {
        return value.toDouble()
    }
    
    var typeName: Hitch {
        return typeHitch
    }
}

