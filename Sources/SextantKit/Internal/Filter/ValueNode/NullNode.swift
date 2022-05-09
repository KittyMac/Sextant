import Foundation
import HitchKit

struct NullNode: ValueNode {
    static let null = NullNode()

    static func == (lhs: NullNode, rhs: NullNode) -> Bool {
        return true
    }

    var description: String {
        return "null"
    }

    var typeName: ValueNodeType {
        return .null
    }

    var literalValue: Hitch? {
        nil
    }

    func stringValue() -> String? {
        return nil
    }

    var numericValue: Double? {
        return nil
    }
}
