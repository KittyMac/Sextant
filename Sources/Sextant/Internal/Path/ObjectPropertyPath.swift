import Foundation
import Hitch
import Spanker

extension JsonAny {
    public func toJsonElement() -> JsonElement {
        switch self {
        case let value as JsonElement:
            return JsonElement(unknown: value)
        case _ as NSNull:
            return JsonElement.null()
        case let value as Bool:
            return JsonElement(unknown: value)
        case let value as Int:
            return JsonElement(unknown: value)
        case let value as Double:
            return JsonElement(unknown: value)
        case let value as Float:
            return JsonElement(unknown: Double(value))
        case let value as NSNumber:
            return JsonElement(unknown: value)
        case let value as Hitch:
            return JsonElement(unknown: value)
        case let value as HalfHitch:
            return JsonElement(unknown: value)
        case let value as StaticString:
            return JsonElement(unknown: value)
        case let value as String:
            return JsonElement(unknown: value)
        case let value as [JsonElementable?]:
            return JsonElement(unknown: value)
        case let value as [String: JsonElementable?]:
            return JsonElement(unknown: value)
        default:
            return JsonElement.null()
        }
    }
}


struct ObjectPropertyPath: Path {
    
    let parentAny: JsonAny

    
    let parentDictionary: JsonDictionary?

    
    let parentArray: JsonArray? = nil

    
    let parentElement: JsonElement?

    
    let propertyString: String?

    
    let propertyHitch: Hitch?

    
    let propertyHalfHitch: HalfHitch?

    
    init(any: JsonAny,
         property: Hitch) {
        parentAny = any
        parentDictionary = nil
        parentElement = nil
        propertyString = nil
        propertyHitch = property
        propertyHalfHitch = nil
    }

    
    init(dictionary: JsonDictionary,
         property: String) {
        parentAny = nil
        parentDictionary = dictionary
        parentElement = nil
        propertyString = property
        propertyHitch = nil
        propertyHalfHitch = nil
    }

    
    init(element: JsonElement,
         property: HalfHitch) {
        parentAny = nil
        parentDictionary = nil
        parentElement = element
        propertyString = nil
        propertyHitch = nil
        propertyHalfHitch = property
    }

    
    @discardableResult
    func set(value: JsonAny) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard parentElement.contains(key: propertyHalfHitch) else { return false }
        parentElement.set(key: propertyHalfHitch, value: value.toJsonElement())
        return true
    }

    
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: propertyHalfHitch] else { return false }
        if let result = block(valueElement) {
            parentElement.set(key: propertyHalfHitch, value: result.toJsonElement())
        } else {
            parentElement.remove(key: propertyHalfHitch)
        }
        return true
    }

    
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: propertyHalfHitch] else { return false }
        block(valueElement)
        return true
    }

    
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        guard parentElement.type == .dictionary else { error("invalid set operation"); return false }
        guard let propertyHalfHitch = propertyHalfHitch else { error("invalid set operation"); return false }
        guard let valueElement = parentElement[element: propertyHalfHitch] else { return false }
        if block(valueElement) == false {
            parentElement.remove(key: propertyHalfHitch)
        }
        return true
    }
}
