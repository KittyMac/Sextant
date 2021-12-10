import Foundation
import Hitch

fileprivate let typeHitch = Hitch("path")

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
    
    func evaluate(context: PredicateContext) -> ValueNode? {
        
        if existsCheck {
            
            guard let evaluationContext = path.evaluate(jsonObject: context.jsonObject,
                                                        rootJsonObject: context.rootJsonObject) else {
                return BooleanNode.false
            }
            
            if evaluationContext.jsonObject() != nil {
                return BooleanNode.true
            }
            return BooleanNode.false
        } else {
            
            let object = context.evaluate(path: path)
            
            if object == nil {
                return BooleanNode.false
            }
            if let _ = object as? NSNull {
                return NullNode()
            }
            if let object = object as? Int {
                return NumberNode(value: object)
            }
            if let object = object as? Double {
                return NumberNode(value: object)
            }
            if let object = object as? Float {
                return NumberNode(value: object)
            }
            if let object = object as? NSNumber {
                return NumberNode(value: object.doubleValue)
            }
            if let object = object as? Bool {
                return BooleanNode(value: object)
            }
            if let object = object as? Hitch {
                return StringNode(hitch: object, escape: false)
            }
            if let object = object as? String {
                return StringNode(hitch: object.hitch())
            }
            if let object = object as? JsonArray {
                return JsonNode(jsonObject: object)
            }
            if let object = object as? JsonDictionary {
                return JsonNode(jsonObject: object)
            }
            
            error("Could not convert \(object ?? "nil") to a ValueNode")
            return nil
        }
    }
    
}
