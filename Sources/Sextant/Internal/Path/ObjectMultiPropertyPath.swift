import Foundation
import Hitch
import Spanker

@usableFromInline
struct ObjectMultiPropertyPath: Path {
    @usableFromInline
    let parentAny: JsonAny = nil

    @usableFromInline
    let parentDictionary: JsonDictionary?

    @usableFromInline
    let parentArray: JsonArray? = nil

    @usableFromInline
    let parentElement: JsonElement?

    @usableFromInline
    let properties: [Hitch]

    @usableFromInline
    init(dictionary: JsonDictionary,
         properties: [Hitch]) {
        parentDictionary = dictionary
        parentElement = nil
        self.properties = properties
    }

    @usableFromInline
    init(element: JsonElement,
         properties: [Hitch]) {
        parentElement = element
        parentDictionary = nil
        self.properties = properties
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
