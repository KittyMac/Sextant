import Foundation
import Hitch

final class ArrayIndexOperation: CustomStringConvertible {
    
    public var indices = [Int]()
    
    public init?(_ operation: Hitch) {
        // check valid chars
        for c in operation where !(c >= CChar.zero && c <= CChar.nine) && c != CChar.comma && c != CChar.space && c != CChar.minus {
            error("Failed to parse ArrayIndexOperation: \(operation)")
            return nil
        }
        
        let tokens = operation.split(separator: UInt8.comma)
        indices.reserveCapacity(tokens.count)
        
        for token in tokens {
            guard let token = token.toInt() else { continue }
            indices.append(token)
        }
    }
    
    public func isSingleIndexOperation() -> Bool {
        return indices.count == 1
    }
    
    public var description: String {
        let value = indices.map { String($0) }.joined(separator: ",")
        return "[\(value)]"
    }
}
