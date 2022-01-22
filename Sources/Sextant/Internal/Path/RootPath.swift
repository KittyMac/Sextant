import Foundation
import Hitch

@usableFromInline
struct RootPath: Path {
    @usableFromInline
    var parent: JsonAny

    @usableFromInline
    var options: EvaluationOptions

    @usableFromInline
    init(rootObject: JsonAny,
         options: EvaluationOptions) {
        parent = rootObject
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
