import Foundation
import HitchKit

struct PatternNode: ValueNode {
    let hitch: Hitch
    let pattern: Hitch
    let flags: Hitch

    let regex: NSRegularExpression

    init?(regex: Hitch) {
        let begin = regex.firstIndex(of: UInt8.forwardSlash) ?? 0
        let end = regex.lastIndex(of: UInt8.forwardSlash) ?? 0

        self.hitch = regex
        self.pattern = regex.substring(begin + 1, end - begin) ?? Hitch.empty
        self.flags = regex.substring(end + 1, regex.count) ?? Hitch.empty

        let localError = error
        do {
            self.regex = try NSRegularExpression(pattern: self.pattern.description,
                                                 options: PatternFlags(flags))
        } catch {
            localError("\(error)")
            return nil
        }
    }

    var description: String {
        return hitch.description
    }

    var typeName: ValueNodeType {
        return .pattern
    }

    var literalValue: Hitch? {
        return nil
    }

    func stringValue() -> String? {
        return nil
    }

    var numericValue: Double? {
        return nil
    }

    func getRegex() -> NSRegularExpression? {
        return regex
    }
}
