import Foundation
import Hitch

final class ArraySliceOperation: CustomStringConvertible {

    public var from: Int?
    public var to: Int?
    public var skip: Int?

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
        if tokens.count >= 3 {
            skip = tokens[2].toInt()
        }
    }

    public var description: String {
        return "[\(from?.description ?? ""):\(to?.description ?? "")]"
    }
}
