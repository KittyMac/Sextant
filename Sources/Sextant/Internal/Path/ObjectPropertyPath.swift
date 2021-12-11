import Foundation
import Hitch

struct ObjectPropertyPath: Path {
    let parent: JsonAny
    let property: Hitch

    init(object: JsonAny,
         property: Hitch) {
        parent = object
        self.property = property
    }
}
