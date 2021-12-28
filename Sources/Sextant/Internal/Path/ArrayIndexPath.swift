import Foundation
import Hitch

@usableFromInline
struct ArrayIndexPath: Path {
    @usableFromInline
    let parent: JsonAny

    @usableFromInline
    let item: JsonAny

    @usableFromInline
    init(object: JsonAny, item: JsonAny) {
        parent = object
        self.item = item
    }
}
