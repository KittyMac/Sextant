import Foundation
import Hitch

public final class ArraySliceOperation: CustomStringConvertible {
    
    public var from: Int?
    public var to: Int?
    
    public init?(_ operation: Hitch) {
        // check valid chars
        for c in operation where !(c >= CChar.zero && c <= CChar.nine) && c != CChar.minus && c != CChar.colon {
            error("Failed to parse SliceOperation (illegal character): \(operation)")
            return nil
        }
        
        let tokens = operation.split(separator: UInt8.colon)
        
        if tokens.count >= 1 {
            if operation[0] == UInt8.colon {
                to = tokens[0].toInt()
            } else {
                from = tokens[0].toInt()
            }
        }
        if tokens.count >= 2 {
            to = tokens[1].toInt()
        }
        
        if from == nil && to == nil {
            error("Failed to parse SliceOperation (from and to are nil): \(operation)")
            return nil
        }
    }
        
    public var description: String {
        return "[\(from?.description ?? ""):\(to?.description ?? "")]"
    }
}
