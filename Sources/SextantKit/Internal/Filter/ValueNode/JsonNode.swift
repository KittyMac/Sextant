import Foundation
import HitchKit

struct JsonNode: ValueNode {
    static func == (lhs: JsonNode, rhs: JsonNode) -> Bool {
        return false // lhs.jsonString == rhs.jsonString && lhs.json == rhs.json
    }

    var jsonString: Hitch?
    let json: JsonAny
    let jsonArray: JsonArray?
    let jsonDictionary: JsonDictionary?

    init(hitch: Hitch) {
        self.jsonString = hitch
        self.json = try? JSONSerialization.jsonObject(with: hitch.dataNoCopy(), options: [])

        if let array = json as? JsonArray {
            self.jsonArray = array
            self.jsonDictionary = nil
        } else if let dictionary = json as? JsonDictionary {
            self.jsonDictionary = dictionary
            self.jsonArray = nil
        } else {
            self.jsonDictionary = nil
            self.jsonArray = nil
        }
    }

    init(array: JsonArray) {
        self.json = array
        self.jsonArray = array
        self.jsonDictionary = nil

        if let data = try? JSONSerialization.data(withJSONObject: array, options: [.sortedKeys]) {
            self.jsonString = Hitch(data: data)
        }
    }

    init(dictionary: JsonDictionary) {
        self.json = dictionary
        self.jsonDictionary = dictionary
        self.jsonArray = nil

        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [.sortedKeys]) {
            self.jsonString = Hitch(data: data)
        }
    }

    var description: String {
        if let value = literalValue {
            return value.description
        }
        return "null"
    }

    var typeName: ValueNodeType {
        return .json
    }

    var literalValue: Hitch? {
        return jsonString
    }

    func stringValue() -> String? {
        return jsonString?.description
    }

    var numericValue: Double? {
        return nil
    }

    func getJsonArray() -> JsonArray? {
        return self.jsonArray
    }

    func getJsonDictionary() -> JsonDictionary? {
        return self.jsonDictionary
    }
}
