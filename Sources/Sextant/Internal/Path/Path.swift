import Foundation
import Hitch
import Spanker

public typealias ForEachObjectBlock = (JsonElement) -> Void
public typealias FilterObjectBlock = (JsonElement) -> Bool

@usableFromInline
protocol Path: CustomStringConvertible {
    var parentAny: JsonAny { get }
    var parentDictionary: JsonDictionary? { get }
    var parentArray: JsonArray? { get }
    var parentElement: JsonElement? { get }

    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext?
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext?
    func isDefinite() -> Bool
    func isFunctionPath() -> Bool
    func isRootPath() -> Bool

    @discardableResult
    func set(value: JsonAny) -> Bool
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool
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
    func forEach(block: ForEachObjectBlock) -> Bool {
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
internal func newPath(array: JsonArray, index: Int, item: JsonAny) -> Path {
    return ArrayIndexPath(array: array, index: index, item: item)
}

@inlinable @inline(__always)
internal func newPath(element: JsonElement, index: Int, item: JsonAny) -> Path {
    return ArrayIndexPath(element: element, index: index, item: item)
}

@inlinable @inline(__always)
internal func newPath(any: JsonAny, property: Hitch) -> Path {
    return ObjectPropertyPath(any: any, property: property)
}

@inlinable @inline(__always)
internal func newPath(dictionary: JsonDictionary, property: String) -> Path {
    return ObjectPropertyPath(dictionary: dictionary, property: property)
}

@inlinable @inline(__always)
internal func newPath(element: JsonElement, property: HalfHitch) -> Path {
    return ObjectPropertyPath(element: element, property: property)
}

@inlinable @inline(__always)
internal func newPath(dictionary: JsonDictionary, properties: [Hitch]) -> Path {
    return ObjectMultiPropertyPath(dictionary: dictionary, properties: properties)
}

@inlinable @inline(__always)
internal func newPath(element: JsonElement, properties: [Hitch]) -> Path {
    return ObjectMultiPropertyPath(element: element, properties: properties)
}
