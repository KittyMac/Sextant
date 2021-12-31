import Foundation
import Hitch

private let trueHitch = Hitch("true")
private let falseHitch = Hitch("false")

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

    func stringValue() -> String? {
        if value {
            return "true"
        }
        return "false"
    }

    var typeName: ValueNodeType {
        return .boolean
    }

    var numericValue: Double? {
        return value ? 1 : 0
    }
}
