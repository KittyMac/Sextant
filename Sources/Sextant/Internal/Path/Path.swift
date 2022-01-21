import Foundation
import Hitch
import Spanker

public typealias MapObjectBlock = (JsonAny, JsonAny) -> Void
public typealias FilterObjectBlock = (JsonAny, JsonAny) -> Void

@usableFromInline
protocol Path: CustomStringConvertible {
    var parent: JsonAny { get }
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext?
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext?
    func isDefinite() -> Bool
    func isFunctionPath() -> Bool
    func isRootPath() -> Bool

    @discardableResult
    func set(value: JsonAny) -> Bool
    @discardableResult
    func map(block: MapObjectBlock) -> Bool
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool
}

extension Path {
    @usableFromInline
    var description: String {
        return "<description missing>"
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

    @usableFromInline
    @discardableResult
    func set(value: JsonAny) -> Bool {
        fatalError("should be overwritten")
    }

    @usableFromInline
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
        fatalError("should be overwritten")
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        fatalError("should be overwritten")
    }
}

@inlinable @inline(__always)
internal func newPath(rootObject: JsonAny,
                      options: EvaluationOptions) -> Path {
    return RootPath(rootObject: rootObject, options: options)
}

@inlinable @inline(__always)
internal func newPath(object: JsonAny, index: Int, item: JsonAny) -> Path {
    return ArrayIndexPath(object: object, index: index, item: item)
}

@inlinable @inline(__always)
internal func newPath(object: JsonAny, property: Hitch) -> Path {
    return ObjectPropertyPath(object: object, property: property)
}

@inlinable @inline(__always)
internal func newPath(object: JsonAny, properties: [Hitch]) -> Path {
    return ObjectMultiPropertyPath(object: object, properties: properties)
}
