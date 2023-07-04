import Foundation
import Hitch
import Spanker

struct PathNode: ValueNode {
    let pathString: Hitch
    let path: Path

    let existsCheck: Bool
    let pathShouldExists: Bool

    init(prebuiltPath: Path) {
        self.path = prebuiltPath
        self.pathString = Hitch(string: prebuiltPath.description)
        self.existsCheck = false
        self.pathShouldExists = false
    }

    init(path pathString: Hitch,
         prebuiltPath: Path,
         existsCheck: Bool,
         shouldExists: Bool) {
        self.pathString = pathString
        self.path = prebuiltPath
        self.existsCheck = existsCheck
        self.pathShouldExists = shouldExists
    }

    init?(path pathString: Hitch,
         existsCheck: Bool,
         shouldExists: Bool) {
        self.pathString = pathString
        self.existsCheck = existsCheck
        self.pathShouldExists = shouldExists

        guard let path = PathCompiler.compile(query: pathString) else {
            return nil
        }
        self.path = path
    }

    func copyForExistsCheck() -> ValueNode {
        guard existsCheck == false else { return self }
        return PathNode(path: pathString,
                        prebuiltPath: path,
                        existsCheck: true,
                        shouldExists: pathShouldExists)
    }

    func shouldExists() -> Bool {
        return pathShouldExists
    }

    var description: String {
        if existsCheck && pathShouldExists == false {
            return "!\(path.description)"
        }
        return path.description
    }

    var literalValue: Hitch? {
        return Hitch(string: description)
    }

    func stringValue() -> String? {
        return description
    }

    var numericValue: Double? {
        return nil
    }

    var typeName: ValueNodeType {
        return .path
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

            let (object, type) = context.evaluate(path: path, options: options)
            if object == nil {
                return nil
            }

            if let type = type {

                switch type {
                case .null:
                    return NullNode.null
                case .int:
                    return NumberNode(value: object.toInt() ?? 0)
                case .double:
                    return NumberNode(value: object.toDouble() ?? 0.0)
                case .boolean:
                    return BooleanNode(value: object as? Bool ?? false)
                case .string, .regex:
                    return StringNode(hitch: object.toHitch() ?? Hitch.empty)
                case .array:
                    return JsonNode(array: object as? JsonArray ?? [])
                case .dictionary:
                    return JsonNode(dictionary: object as? JsonDictionary ?? [:])
                }

            } else {
                switch object {
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
                    return StringNode(hitch: Hitch(string: value))
                case let value as JsonArray:
                    return JsonNode(array: value)
                case let value as JsonDictionary:
                    return JsonNode(dictionary: value)
                default:
                    error("Could not convert \(object ?? "nil") to a ValueNode")
                    return nil
                }
            }
        }
    }

}
