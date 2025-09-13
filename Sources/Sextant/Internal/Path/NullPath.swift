import Foundation
import Hitch
import Spanker


struct NullPath: Path {
    
    let parentAny: JsonAny = nil

    
    let parentDictionary: JsonDictionary? = nil

    
    let parentArray: JsonArray? = nil

    
    let parentElement: JsonElement? = nil

    
    static let shared = NullPath()

    
    var description: String {
        return "null"
    }

    
    @discardableResult
    func set(value: JsonAny) -> Bool {
        return true
    }

    
    @discardableResult
    func map(block: ForEachObjectBlock) -> Bool {
        return true
    }

    
    @discardableResult
    func forEach(block: ForEachObjectBlock) -> Bool {
        return true
    }

    
    @discardableResult
    func filter(block: FilterObjectBlock) -> Bool {
        return true
    }
}
