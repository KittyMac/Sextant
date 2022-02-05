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

    @inlinable @inline(__always)
    init(any: JsonAny,
         property: Hitch) {
        parentAny = any
        parentDictionary = nil
        parentElement = nil
        propertyString = nil
        propertyHitch = property
        propertyHalfHitch = nil
    }

    @inlinable @inline(__always)
    init(dictionary: JsonDictionary,
         property: String) {
        parentAny = nil
        parentDictionary = dictionary
        parentElement = nil
        propertyString = property
        propertyHitch = nil
        propertyHalfHitch = nil
    }

    @inlinable @inline(__always)
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
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard parentElement.contains(key: propertyHalfHitch) else { return false }
        parentElement.set(key: propertyHalfHitch, value: JsonElement(unknown: value))
        return true
    }

    @usableFromInline
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: propertyHalfHitch] else { return false }
        if let result = block(valueElement) {
            parentElement.set(key: propertyHalfHitch, value: result)
        } else {
            parentElement.remove(key: propertyHalfHitch)
        }
        return true
    }

    @usableFromInline
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: propertyHalfHitch] else { return false }
        block(valueElement)
        return true
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: propertyHalfHitch] else { return false }
        if block(valueElement) == false {
            parentElement.remove(key: propertyHalfHitch)
        }
        return true
    }
}
