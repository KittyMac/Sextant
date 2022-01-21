import Foundation
import Hitch

@usableFromInline
struct ObjectMultiPropertyPath: Path {
    @usableFromInline
    let parent: JsonAny

    @usableFromInline
    let properties: [Hitch]

    @usableFromInline
    init(object: JsonAny,
         properties: [Hitch]) {
        parent = object
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
