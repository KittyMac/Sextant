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
        guard count > 0 else { return Hitch() }

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

enum EvaluationStatus: Equatable {
    case done
    case aborted
    case error(_ error: String)

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
    class func combine(_ parts: Hitch...) -> Hitch {
        guard parts.count > 0 else { return Hitch() }

        var total = 0
        parts.forEach { total += $0.count }

        let buffer = Hitch(capacity: total)
        parts.forEach { buffer.append($0) }
        return buffer
    }

    @discardableResult
    @inlinable
    class func make(path: Hitch, index: Int) -> Hitch {
        let clone = Hitch(hitch: path)
        clone.reserveCapacity(clone.count + 32)

        clone.append(UInt8.openBrace)
        clone.append(number: index)
        clone.append(UInt8.closeBrace)

        return clone
    }

    @discardableResult
    @inlinable
    class func make(path: Hitch, property: Hitch) -> Hitch {
        let clone = Hitch(hitch: path)
        clone.reserveCapacity(clone.count + property.count + 2)
        clone.append(UInt8.openBrace)
        clone.append(property)
        clone.append(UInt8.closeBrace)
        return clone
    }

    @discardableResult
    @inlinable
    class func make(path: Hitch, property: Hitch, wrap: UInt8) -> Hitch {
        let clone = Hitch(hitch: path)
        clone.reserveCapacity(clone.count + property.count + 4)
        clone.append(UInt8.openBrace)
        clone.append(wrap)
        clone.append(property)
        clone.append(wrap)
        clone.append(UInt8.closeBrace)
        return clone
    }

    @discardableResult
    @inlinable
    class func make(path: Hitch, property: HalfHitch, wrap: UInt8) -> Hitch {
        let clone = Hitch(hitch: path)
        clone.reserveCapacity(clone.count + property.count + 4)
        clone.append(UInt8.openBrace)
        clone.append(wrap)
        clone.append(property)
        clone.append(wrap)
        clone.append(UInt8.closeBrace)
        return clone
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, index: Int) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(number: index)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: Hitch) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(property)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: Hitch, wrap: UInt8) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(wrap)
        hitch.append(property)
        hitch.append(wrap)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: String, wrap: UInt8) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(wrap)
        hitch.append(property)
        hitch.append(wrap)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: HalfHitch) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(property)
        hitch.append(UInt8.closeBrace)
    }

    @inlinable
    class func replace(hitch: Hitch, path: Hitch, property: HalfHitch, wrap: UInt8) {
        hitch.replace(with: path)
        hitch.append(UInt8.openBrace)
        hitch.append(wrap)
        hitch.append(property)
        hitch.append(wrap)
        hitch.append(UInt8.closeBrace)
    }
}
