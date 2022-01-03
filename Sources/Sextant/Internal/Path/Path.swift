import Foundation
import Hitch
import Spanker

@usableFromInline
protocol Path: CustomStringConvertible {
    var parent: JsonAny { get }
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext?
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext?
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
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext? {
        fatalError("should be overwritten")
    }

    @usableFromInline
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext? {
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
internal func newPath(rootObject: JsonAny,
                      options: EvaluationOptions) -> Path {
    return RootPath(rootObject: rootObject, options: options)
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
