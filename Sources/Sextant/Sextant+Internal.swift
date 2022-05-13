import Foundation
import Hitch

func anyEquals(_ a: JsonAny, _ b: JsonAny?) -> Bool {
    if a == nil && b == nil { return true }
    if let a = a as? CustomStringConvertible,
       let b = b as? CustomStringConvertible {
        if a.description == b.description {
            return true
        }
    }
    return false
}

func error(_ error: String) {
    #if DEBUG
    // print("Error: " + error)
    #endif
}

extension Array where Element == Hitch {
    func joined(delimiter: UInt8, wrap: UInt8) -> Hitch {
        guard count > 0 else { return Hitch.empty }

        var total = 0
        forEach { total += $0.count + 2 }

        let buffer = Hitch(capacity: total)

        forEach { part in
            if buffer.count > 0 {
                buffer.append(delimiter)
            }
            buffer.append(wrap)
            buffer.append(part)
            buffer.append(wrap)
        }

        return buffer
    }
}

enum ArrayPathCheck: Equatable {
    case handle
    case skip
    case error(String)

    static func == (lhs: ArrayPathCheck, rhs: ArrayPathCheck) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.handle, .handle):
            return true
        case (.skip, .skip):
            return true

        default:
            return false
        }
    }
}

@usableFromInline
enum EvaluationStatus: Equatable {
    case done
    case aborted
    case error(_ error: String)

    @usableFromInline
    static func == (lhs: EvaluationStatus, rhs: EvaluationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.done, .done):
            return true
        case (.aborted, .aborted):
            return true

        default:
            return false
        }
    }
}

extension Hitch {

    @inlinable @inline(__always)
    class func appending<T>(hitch: Hitch,
                         block: () -> (T),
                         execute: () -> Void) -> T {
        let savedCount = hitch.count
        defer { hitch.count = savedCount }
        execute()
        return block()
    }

    @inlinable @inline(__always)
    class func appending<T>(hitch: Hitch,
                            parts: [Hitch],
                            _ block: () -> (T)) -> T {
        return appending(hitch: hitch, block: block) {
            var total = hitch.count
            parts.forEach { total += $0.count }

            hitch.reserveCapacity(total * 2)
            parts.forEach { hitch.append($0) }
        }
    }

    @inlinable @inline(__always)
    class func appending<T>(hitch: Hitch,
                            index: Int,
                            _ block: () -> (T)) -> T {
        return appending(hitch: hitch, block: block) {
            hitch.reserveCapacity((hitch.count + 32) * 2)
            hitch.append(UInt8.openBrace)
            hitch.append(number: index)
            hitch.append(UInt8.closeBrace)
        }
    }

    @inlinable @inline(__always)
    class func appending<T>(hitch: Hitch,
                            property: Hitch,
                            _ block: () -> (T)) -> T {
        return appending(hitch: hitch, block: block) {
            hitch.reserveCapacity((hitch.count + 2 + property.count) * 2)
            hitch.append(UInt8.openBrace)
            hitch.append(property)
            hitch.append(UInt8.closeBrace)
        }
    }

    @inlinable @inline(__always)
    class func appending<T>(hitch: Hitch,
                            property: Hitch,
                            wrap: UInt8,
                            _ block: () -> (T)) -> T {
        return appending(hitch: hitch, block: block) {
            hitch.reserveCapacity((hitch.count + 4 + property.count) * 2)
            hitch.append(UInt8.openBrace)
            hitch.append(wrap)
            hitch.append(property)
            hitch.append(wrap)
            hitch.append(UInt8.closeBrace)
        }
    }

    @inlinable @inline(__always)
    class func appending<T>(hitch: Hitch,
                            property: HalfHitch,
                            wrap: UInt8,
                            _ block: () -> (T)) -> T {
        return appending(hitch: hitch, block: block) {
            hitch.reserveCapacity((hitch.count + 4 + property.count) * 2)
            hitch.append(UInt8.openBrace)
            hitch.append(wrap)
            hitch.append(property)
            hitch.append(wrap)
            hitch.append(UInt8.closeBrace)
        }
    }

    @inlinable @inline(__always)
    class func appending<T>(hitch: Hitch,
                            property: String,
                            wrap: UInt8,
                            _ block: () -> (T)) -> T {
        return appending(hitch: hitch, block: block) {
            hitch.reserveCapacity((hitch.count + 4 + property.count) * 2)
            hitch.append(UInt8.openBrace)
            hitch.append(wrap)
            hitch.append(property)
            hitch.append(wrap)
            hitch.append(UInt8.closeBrace)
        }
    }

}
