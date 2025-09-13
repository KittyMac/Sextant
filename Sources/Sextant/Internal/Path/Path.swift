import Foundation
import Hitch
import Spanker

public typealias MapObjectBlock = (JsonElement) -> JsonAny?
public typealias ForEachObjectBlock = (JsonElement) -> Void
public typealias FilterObjectBlock = (JsonElement) -> Bool


protocol Path: CustomStringConvertible {
    var parentAny: JsonAny { get }
    var parentDictionary: JsonDictionary? { get }
    var parentArray: JsonArray? { get }
    var parentElement: JsonElement? { get }
    var index: Int { get }

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
    func forEach(block: ForEachObjectBlock) -> Bool
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool
}

extension Path {
    
    var index: Int {
        return 0
    }

    
    var description: String {
        return "<description missing>"
    }

    
    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny, options: EvaluationOptions) -> EvaluationContext? {
        // fatalError("should be overwritten")
        return nil
    }

    
    func evaluate(jsonElement: JsonElement, rootJsonElement: JsonElement, options: EvaluationOptions) -> EvaluationContext? {
        // fatalError("should be overwritten")
        return nil
    }

    
    func isDefinite() -> Bool {
        // fatalError("should be overwritten")
        return false
    }

    
    func isFunctionPath() -> Bool {
        // fatalError("should be overwritten")
        return false
    }

    
    func isRootPath() -> Bool {
        // fatalError("should be overwritten")
        return false
    }

    
    @discardableResult
    func set(value: JsonAny) -> Bool {
        // fatalError("should be overwritten")
        return false
    }

    
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
        // fatalError("should be overwritten")
        return false
    }

    
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        // fatalError("should be overwritten")
        return false
    }

    
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        // fatalError("should be overwritten")
        return false
    }
}


internal func newPath(rootObject: JsonAny,
                      options: EvaluationOptions) -> Path {
    return RootPath(rootObject: rootObject, options: options)
}


internal func newPath(rootElement: JsonElement,
                      options: EvaluationOptions) -> Path {
    return RootPath(rootElement: rootElement, options: options)
}


internal func newPath(array: JsonArray, index: Int, item: JsonAny) -> Path {
    return ArrayIndexPath(array: array, index: index, item: item)
}


internal func newPath(element: JsonElement, index: Int, item: JsonAny) -> Path {
    return ArrayIndexPath(element: element, index: index, item: item)
}


internal func newPath(any: JsonAny, property: Hitch) -> Path {
    return ObjectPropertyPath(any: any, property: property)
}


internal func newPath(dictionary: JsonDictionary, property: String) -> Path {
    return ObjectPropertyPath(dictionary: dictionary, property: property)
}


internal func newPath(element: JsonElement, property: HalfHitch) -> Path {
    return ObjectPropertyPath(element: element, property: property)
}
