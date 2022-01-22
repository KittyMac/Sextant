import Foundation
import Hitch
import Spanker

@usableFromInline
struct RootPath: Path {
    @usableFromInline
    let parentAny: JsonAny

    @usableFromInline
    let parentDictionary: JsonDictionary? = nil

    @usableFromInline
    let parentArray: JsonArray? = nil

    @usableFromInline
    let parentElement: JsonElement? = nil

    @usableFromInline
    var options: EvaluationOptions

    @usableFromInline
    init(rootObject: JsonAny,
         options: EvaluationOptions) {
        parentAny = rootObject
        self.options = options
    }

    @usableFromInline
    @discardableResult
    func set(value: JsonAny) -> Bool {
        error("invalid set operation")
        return false
    }

    @usableFromInline
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        error("invalid set operation")
        return false
    }

    @usableFromInline
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        error("invalid set operation")
        return false
    }
}
