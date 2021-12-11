import Foundation
import Hitch

class Path: CustomStringConvertible {
    class func newPath(rootObject: JsonAny) -> Path {
        return RootPath(rootObject: rootObject)
    }
    class func newPath(object: JsonAny, item: JsonAny) -> Path {
        return ArrayIndexPath(object: object, item: item)
    }
    class func newPath(object: JsonAny, property: Hitch) -> Path {
        return ObjectPropertyPath(object: object, property: property)
    }
    class func newPath(object: JsonAny, properties: [Hitch]) -> Path {
        return ObjectMultiPropertyPath(object: object, properties: properties)
    }
    class func nullPath() -> Path {
        return NullPath.shared
    }

    var parent: JsonAny

    init(parent: JsonAny) {
        self.parent = parent
    }

    var description: String {
        return ""
    }

    func evaluate(jsonObject: JsonAny, rootJsonObject: JsonAny) -> EvaluationContext? {
        fatalError("TO BE IMPLEMENTED")
        // return nil
    }

    func isDefinite() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        // return false
    }

    func isFunctionPath() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        // return false
    }

    func isRootPath() -> Bool {
        fatalError("TO BE IMPLEMENTED")
        // return false
    }
}
