import Foundation
import Hitch
import Spanker

@usableFromInline
struct ArrayIndexPath: Path {
    @usableFromInline
    let parentAny: JsonAny = nil

    @usableFromInline
    let parentDictionary: JsonDictionary? = nil

    @usableFromInline
    let parentArray: JsonArray?

    @usableFromInline
    let parentElement: JsonElement?

    @usableFromInline
    let item: JsonAny

    @usableFromInline
    let index: Int

    @usableFromInline
    init(array: JsonArray,
         index: Int,
         item: JsonAny) {
        parentArray = array
        parentElement = nil
        self.index = index
        self.item = item
    }

    @usableFromInline
    init(element: JsonElement,
         index: Int,
         item: JsonAny) {
        parentArray = nil
        parentElement = element
        self.index = index
        self.item = item
    }

    @usableFromInline
    @discardableResult
    func set(value: JsonAny) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .array else { error("invalid set operation"); return false }
        parentElement.valueArray[index] = JsonElement(unknown: value)
        return true
    }

    @usableFromInline
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .array else { error("invalid set operation"); return false }
        block(parentElement.valueArray[index])
        return true
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .array else { error("invalid set operation"); return false }
        parentElement.valueArray = parentElement.valueArray.filter(block)
        return true
    }
}
