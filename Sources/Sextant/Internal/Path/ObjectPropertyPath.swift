import Foundation
import Hitch
import Spanker

@usableFromInline
struct ObjectPropertyPath: Path {
    @usableFromInline
    let parentAny: JsonAny

    @usableFromInline
    let parentDictionary: JsonDictionary?

    @usableFromInline
    let parentArray: JsonArray? = nil

    @usableFromInline
    let parentElement: JsonElement?

    @usableFromInline
    let propertyString: String?

    @usableFromInline
    let propertyHitch: Hitch?

    @usableFromInline
    let propertyHalfHitch: HalfHitch?

    @usableFromInline
    init(any: JsonAny,
         property: Hitch) {
        parentAny = any
        parentDictionary = nil
        parentElement = nil
        propertyString = nil
        propertyHitch = property
        propertyHalfHitch = nil
    }

    @usableFromInline
    init(dictionary: JsonDictionary,
         property: String) {
        parentAny = nil
        parentDictionary = dictionary
        parentElement = nil
        propertyString = property
        propertyHitch = nil
        propertyHalfHitch = nil
    }

    @usableFromInline
    init(element: JsonElement,
         property: HalfHitch) {
        parentAny = nil
        parentDictionary = nil
        parentElement = element
        propertyString = nil
        propertyHitch = nil
        propertyHalfHitch = property
    }

    @usableFromInline
    @discardableResult
    func set(value: JsonAny) -> Bool {
        error("TO BE IMPLEMENTED")
        return false
    }

    @usableFromInline
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        error("TO BE IMPLEMENTED")
        return false
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        error("TO BE IMPLEMENTED")
        return false
    }
}
