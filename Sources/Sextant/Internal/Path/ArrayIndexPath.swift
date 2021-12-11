import Foundation
import Hitch

struct ArrayIndexPath: Path {
    let parent: JsonAny
    let item: JsonAny

    init(object: JsonAny, item: JsonAny) {
        parent = object
        self.item = item
    }
}
