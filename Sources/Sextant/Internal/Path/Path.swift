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
        fatalError("TO BE IMPLEMENTED")
    }

    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext? {
        fatalError("TO BE IMPLEMENTED")
    }

    func isDefinite() -> Bool {
        fatalError("TO BE IMPLEMENTED")
    }

    func isFunctionPath() -> Bool {
        fatalError("TO BE IMPLEMENTED")
    }

    func isRootPath() -> Bool {
        fatalError("TO BE IMPLEMENTED")
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
