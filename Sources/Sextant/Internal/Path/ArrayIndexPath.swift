import Foundation
import Hitch
import Spanker


struct ArrayIndexPath: Path {
    
    let parentAny: JsonAny = nil

    
    let parentDictionary: JsonDictionary? = nil

    
    let parentArray: JsonArray?

    
    let parentElement: JsonElement?

    
    let item: JsonAny

    
    let index: Int

    
    init(array: JsonArray,
         index: Int,
         item: JsonAny) {
        parentArray = array
        parentElement = nil
        self.index = index
        self.item = item
    }

    
    init(element: JsonElement,
         index: Int,
         item: JsonAny) {
        parentArray = nil
        parentElement = element
        self.index = index
        self.item = item
    }

    
    @discardableResult
    func set(value: JsonAny) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .array else { error("invalid set operation"); return false }
        guard index >= 0 && index < parentElement.count else { return false }
        parentElement.replace(at: index, value: value.toJsonElement())
        return true
    }

    
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .array else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: index] else { return false }
        if let result = block(valueElement) {
            parentElement.replace(at: index, value: result.toJsonElement())
        } else {
            parentElement.remove(at: index)
        }
        return true
    }

    
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .array else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: index] else { return false }
        block(valueElement)
        return true
    }

    
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .array else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: index] else { return false }
        if block(valueElement) == false {
            parentElement.remove(at: index)
        }
        return true
    }
}
