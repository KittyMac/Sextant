import Foundation
import HitchKit

func PatternFlags(_ hitch: Hitch) -> NSRegularExpression.Options {
    var options = NSRegularExpression.Options()
    for c in hitch {
        switch c {
        case .d:
            options.insert(.useUnixLineSeparators)
        case .i:
            options.insert(.caseInsensitive)
        case .x:
            options.insert(.allowCommentsAndWhitespace)
        case .m:
            options.insert(.anchorsMatchLines)
        case .s:
            options.insert(.dotMatchesLineSeparators)
        default:
            break
        }
    }
    return options
}
