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
        guard let parent = parent as? JsonElement else { error("invalid set operation"); return false }
        guard parent.type == .array else { error("invalid set operation"); return false }
        parent.valueArray[index] = JsonElement(unknown: value)
        return true
    }

    @usableFromInline
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        guard let parent = parent as? JsonElement else { error("invalid set operation"); return false }
        guard parent.type == .array else { error("invalid set operation"); return false }
        block(parent.valueArray[index])
        return true
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        guard let parent = parent as? JsonElement else { error("invalid set operation"); return false }
        guard parent.type == .array else { error("invalid set operation"); return false }
        parent.valueArray = parent.valueArray.filter(block)
        return true
    }
}
