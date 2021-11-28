import Foundation

public typealias JsonAny = Any?

func error(_ error: String) {
    print("Error: " + error)
}

public enum ArrayPathCheck: Equatable {
    case handle
    case skip
    case error(String)
    
    public static func == (lhs: ArrayPathCheck, rhs: ArrayPathCheck) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true

        default:
            return lhs == rhs
        }
    }
}

public enum EvaluationStatus: Equatable {
    case done
    case aborted
    case error(_ error: String)
    
    public static func == (lhs: EvaluationStatus, rhs: EvaluationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true

        default:
            return lhs == rhs
        }
    }
}

public final class Sextant {
    
}
