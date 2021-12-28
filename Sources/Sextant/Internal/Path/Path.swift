import Foundation
import Hitch
import Spanker

@usableFromInline
protocol Path: CustomStringConvertible {
    var parent: JsonAny { get }
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext?
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement) -> EvaluationContext?
    func isDefinite() -> Bool
    func isFunctionPath() -> Bool
    func isRootPath() -> Bool
}

extension Path {
    @usableFromInline
    var description: String {
        fatalError("should be overwritten")
    }

    @usableFromInline
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext? {
        fatalError("should be overwritten")
    }

    @usableFromInline
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement) -> EvaluationContext? {
        fatalError("should be overwritten")
    }

    @usableFromInline
    func isDefinite() -> Bool {
        fatalError("should be overwritten")
    }

    @usableFromInline
    func isFunctionPath() -> Bool {
        fatalError("should be overwritten")
    }

    @usableFromInline
    func isRootPath() -> Bool {
        fatalError("should be overwritten")
    }
}

@inlinable @inline(__always)
internal func newPath(rootObject: JsonAny) -> Path {
    return RootPath(rootObject: rootObject)
}

@inlinable @inline(__always)
internal func newPath(object: JsonAny, item: JsonAny) -> Path {
    return ArrayIndexPath(object: object, item: item)
}

@inlinable @inline(__always)
internal func newPath(object: JsonAny, property: Hitch) -> Path {
    return ObjectPropertyPath(object: object, property: property)
}

@inlinable @inline(__always)
internal func newPath(object: JsonAny, properties: [Hitch]) -> Path {
    return ObjectMultiPropertyPath(object: object, properties: properties)
}

@inlinable @inline(__always)
internal func nullPath() -> Path {
    return NullPath.shared
}
