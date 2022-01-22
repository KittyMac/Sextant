import Foundation
import Hitch

@usableFromInline
struct ObjectPropertyPath: Path {
    @usableFromInline
    let parent: JsonAny

    @usableFromInline
    let property: Hitch

    @usableFromInline
    init(object: JsonAny,
         property: Hitch) {
        parent = object
        self.property = property
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
