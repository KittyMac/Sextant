import Foundation
import Hitch

class CompiledFilter: Filter {
    let predicate: Predicate
    
    init(predicate: Predicate) {
        self.predicate = predicate
    }
}
