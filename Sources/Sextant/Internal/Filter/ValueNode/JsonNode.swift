import Foundation
import Hitch

fileprivate let typeHitch = Hitch("json")


class JsonNode: ValueNode {
    static func == (lhs: JsonNode, rhs: JsonNode) -> Bool {
        return false //lhs.jsonString == rhs.jsonString && lhs.json == rhs.json
    }
    
    var jsonString: Hitch?
    let json: JsonAny
        
    init(hitch: Hitch) {
        self.jsonString = hitch
        self.json = try? JSONSerialization.jsonObject(with: hitch.dataNoCopy(), options: [])
    }
    
    init(jsonObject: JsonAny) {
        self.json = jsonObject
        if let jsonObject = jsonObject,
           let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            self.jsonString = Hitch(data: data)
        }
    }
    
    var description: String {
        if let value = literalValue {
            return value.description
        }
        return "null"
    }
        
    var typeName: Hitch {
        return typeHitch
    }
    
    var literalValue: Hitch? {
        return jsonString
    }
    
    var numericValue: Double? {
        return nil
    }
}
