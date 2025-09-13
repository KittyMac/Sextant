import Foundation
import Hitch
import Spanker


struct RootPath: Path {
    
    let parentAny: JsonAny

    
    let parentDictionary: JsonDictionary? = nil

    
    let parentArray: JsonArray? = nil

    
    var parentElement: JsonElement?

    
    var options: EvaluationOptions

    
    init(rootObject: JsonAny,
         options: EvaluationOptions) {
        parentAny = rootObject
        parentElement = nil
        self.options = options
    }

    
    init(rootElement: JsonElement?,
         options: EvaluationOptions) {
        parentAny = nil
        parentElement = rootElement
        self.options = options
    }

    
    @discardableResult
    func set(value: JsonAny) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        parentElement.replace(with: value.toJsonElement())
        return false
    }

    
    @discardableResult
    func map(block: MapObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        self.parentElement?.replace(with: block(parentElement)?.toJsonElement() ?? JsonElement.null())
        return true
    }

    
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        block(parentElement)
        return true
    }

    
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        guard let parentElement = parentElement else { error("invalid set operation"); return false }
        if block(parentElement) == false {
            self.parentElement?.replace(with: JsonElement.null())
        }
        return true
    }
}
