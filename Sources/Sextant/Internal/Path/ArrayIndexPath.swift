import Foundation
import Hitch


final class ArrayIndexPath: Path {
    var item: JsonAny
    
    init(object: JsonAny, item: JsonAny) {
        self.item = item
        
        super.init(parent: object)
    }
}
