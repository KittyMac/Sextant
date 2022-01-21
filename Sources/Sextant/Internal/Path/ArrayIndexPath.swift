import Foundation
import Hitch
import Spanker

@usableFromInline
struct ArrayIndexPath: Path {
    @usableFromInline
    let parent: JsonAny

    @usableFromInline
    let item: JsonAny

    @usableFromInline
    let index: Int

    @usableFromInline
    init(object: JsonAny,
         index: Int,
         item: JsonAny) {
        parent = object
        self.index = index
        self.item = item
    }

    @usableFromInline
    @discardableResult
    func set(value: JsonAny) -> Bool {
        if var array = parent as? JsonArray {
            array[index] = value
            return true
        } else if let array = parent as? JsonElement,
                  array.type == .array {
            array.valueArray[index] = JsonElement(unknown: value)
            return true
        }

        error("invalid set operation")
        return false
    }

    @usableFromInline
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
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
