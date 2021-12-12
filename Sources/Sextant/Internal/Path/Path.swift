import Foundation
import Hitch

protocol Path: CustomStringConvertible {

    var parent: JsonAny { get }

    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext?

    func isDefinite() -> Bool

    func isFunctionPath() -> Bool

    func isRootPath() -> Bool
}

extension Path {
    var description: String {
        fatalError("should be overwritten")
    }

    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext? {
        fatalError("should be overwritten")
    }

    func isDefinite() -> Bool {
        fatalError("should be overwritten")
    }

    func isFunctionPath() -> Bool {
        fatalError("should be overwritten")
    }

    func isRootPath() -> Bool {
        fatalError("should be overwritten")
    }
}

func newPath(rootObject: JsonAny) -> Path {
    return RootPath(rootObject: rootObject)
}
func newPath(object: JsonAny, item: JsonAny) -> Path {
    return ArrayIndexPath(object: object, item: item)
}
func newPath(object: JsonAny, property: Hitch) -> Path {
    return ObjectPropertyPath(object: object, property: property)
}
func newPath(object: JsonAny, properties: [Hitch]) -> Path {
    return ObjectMultiPropertyPath(object: object, properties: properties)
}
func nullPath() -> Path {
    return NullPath.shared
}
