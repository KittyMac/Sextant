import Foundation
import Hitch

@usableFromInline
struct NullPath: Path {
    @usableFromInline
    let parent: JsonAny = nil

    @usableFromInline
    static let shared = NullPath()

    @usableFromInline
    var description: String {
        return "null"
    }

    @usableFromInline
    @discardableResult
    func set(value: JsonAny) -> Bool {
        return true
    }

    @usableFromInline
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        return true
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        return true
    }
}
