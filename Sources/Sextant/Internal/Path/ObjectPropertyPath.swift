import Foundation
import Hitch

@usableFromInline
struct ObjectPropertyPath: Path {
    @usableFromInline
    let parent: JsonAny

    @usableFromInline
    let property: Hitch

    @usableFromInline
    init(object: JsonAny,
         property: Hitch) {
        parent = object
        self.property = property
    }
}
