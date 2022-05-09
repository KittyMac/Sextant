import Foundation
import HitchKit
import SpankerKit

@usableFromInline
struct NullPath: Path {
    @usableFromInline
    let parentAny: JsonAny = nil

    @usableFromInline
    let parentDictionary: JsonDictionary? = nil

    @usableFromInline
    let parentArray: JsonArray? = nil

    @usableFromInline
    let parentElement: JsonElement? = nil

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
    func map(block: ForEachObjectBlock) -> Bool {
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
