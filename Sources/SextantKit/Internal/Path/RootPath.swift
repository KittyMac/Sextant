import Foundation
import HitchKit
import SpankerKit

@usableFromInline
struct RootPath: Path {
    @usableFromInline
    let parentAny: JsonAny

    @usableFromInline
    let parentDictionary: JsonDictionary? = nil

    @usableFromInline
    let parentArray: JsonArray? = nil

    @usableFromInline
    var parentElement: JsonElement?

    @usableFromInline
    var options: EvaluationOptions

    @usableFromInline
    init(rootObject: JsonAny,
         options: EvaluationOptions) {
        parentAny = rootObject
        parentElement = nil
        self.options = options
    }

    @usableFromInline
    init(rootElement: JsonElement?,
         options: EvaluationOptions) {
        parentAny = nil
        parentElement = rootElement
        self.options = options
    }

    @usableFromInline
    @discardableResult
    func set(value: JsonAny) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        parentElement.replace(with: value.toJsonElement())
        return false
    }

    @usableFromInline
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        self.parentElement?.replace(with: block(parentElement)?.toJsonElement() ?? JsonElement.null())
        return true
    }

    @usableFromInline
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        block(parentElement)
        return true
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        if block(parentElement) == false {
            self.parentElement?.replace(with: JsonElement.null())
        }
        return true
    }
}
