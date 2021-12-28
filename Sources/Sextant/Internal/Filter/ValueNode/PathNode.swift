import Foundation
import Hitch

private let typeHitch = Hitch("path")

struct PathNode: ValueNode {
    let pathString: Hitch
    let path: Path

    let existsCheck: Bool
    let shouldExists: Bool

    init(prebuiltPath: Path) {
        self.path = prebuiltPath
        self.pathString = prebuiltPath.description.hitch()
        self.existsCheck = false
        self.shouldExists = false
    }

    init(path pathString: Hitch,
         prebuiltPath: Path,
         existsCheck: Bool,
         shouldExists: Bool) {
        self.pathString = pathString
        self.path = prebuiltPath
        self.existsCheck = existsCheck
        self.shouldExists = shouldExists
    }

    init?(path pathString: Hitch,
         existsCheck: Bool,
         shouldExists: Bool) {
        self.pathString = pathString
        self.existsCheck = existsCheck
        self.shouldExists = shouldExists

        guard let path = PathCompiler.compile(query: pathString) else {
            return nil
        }
        self.path = path
    }

    func copy(existsCheck: Bool,
              shouldExists: Bool) -> PathNode {
        return PathNode(path: pathString,
                        prebuiltPath: path,
                        existsCheck: existsCheck,
                        shouldExists: shouldExists)
    }

    var description: String {
        if existsCheck && shouldExists == false {
            return "!\(path.description)"
        }
        return path.description
    }

    var literalValue: Hitch? {
        return description.hitch()
    }

    var numericValue: Double? {
        return nil
    }

    var typeName: Hitch {
        return typeHitch
    }

    func evaluate(context: PredicateContext, options: EvaluationOptions) -> ValueNode? {

        if existsCheck {

            if context.jsonObject != nil {
                guard let evaluationContext = path.evaluate(jsonObject: context.jsonObject,
                                                            rootJsonObject: context.rootJsonObject,
                                                            options: options) else {
                    return BooleanNode.false
                }

                if evaluationContext.jsonObject() != nil {
                    return BooleanNode.true
                }
                return BooleanNode.false
            } else {
                guard let evaluationContext = path.evaluate(jsonElement: context.jsonElement,
                                                            rootJsonElement: context.rootJsonElement,
                                                            options: options) else {
                    return BooleanNode.false
                }

                if evaluationContext.jsonObject() != nil {
                    return BooleanNode.true
                }
                return BooleanNode.false
            }

        } else {

            let object = context.evaluate(path: path, options: options)

            switch object {
            case nil:
                return BooleanNode.false
            case _ as NSNull:
                return NullNode.null
            case let value as Int:
                return NumberNode(value: value)
            case let value as Double:
                return NumberNode(value: value)
            case let value as Float:
                return NumberNode(value: value)
            case let value as NSNumber:
                return NumberNode(value: value.doubleValue)
            case let value as Bool:
                return BooleanNode(value: value)
            case let value as Hitch:
                return StringNode(hitch: value, escape: false)
            case let value as HalfHitch:
                return StringNode(hitch: value.hitch(), escape: false)
            case let value as String:
                return StringNode(hitch: value.hitch())
            case let value as JsonArray:
                return JsonNode(jsonObject: value)
            case let value as JsonDictionary:
                return JsonNode(jsonObject: value)
            default:
                error("Could not convert \(object ?? "nil") to a ValueNode")
                return nil
            }
        }
    }

}
