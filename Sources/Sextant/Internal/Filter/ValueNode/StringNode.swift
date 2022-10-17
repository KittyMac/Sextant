import Foundation
import Hitch

struct StringNode: ValueNode {
    var valueAsString: String?
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
            } else if start == .doubleQuote && end == .doubleQuote {
                useSingleQuote = false
                localValue = localValue.substring(1, hitch.count - 1) ?? localValue
            } else {
                useSingleQuote = true
            }
        } else {
            useSingleQuote = false
        }

        if escape {
            self.value = localValue.unicodeUnescaped()
        } else {
            self.value = localValue
        }
    }

    init(hitch: Hitch) {
        useSingleQuote = false
        self.value = hitch
    }

    var description: String {
        let escaped = value.escaped(unicode: false,
                                    singleQuotes: useSingleQuote)
        if useSingleQuote {
            return "'\(escaped)'"
        }
        return "\"\(escaped)\""
    }

    var literalValue: Hitch? {
        return value
    }

    func stringValue() -> String? {
        return value.description
    }

    var numericValue: Double? {
        return value.toDouble()
    }

    var typeName: ValueNodeType {
        return .string
    }
}
