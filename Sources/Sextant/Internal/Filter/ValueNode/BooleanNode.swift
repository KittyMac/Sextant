import Foundation
import Hitch

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
        if let raw = hitch.raw(),
           hitch.count == 4 &&
            (raw[0] == .t || raw[0] == .T) &&
            (raw[1] == .r || raw[1] == .R) &&
            (raw[2] == .u || raw[2] == .U) &&
            (raw[3] == .e || raw[3] == .E) {
            self.value = true
        } else {
            self.value = false
        }
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
