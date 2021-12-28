import Foundation
import Hitch

@usableFromInline
struct ObjectMultiPropertyPath: Path {
    @usableFromInline
    let parent: JsonAny

    @usableFromInline
    let properties: [Hitch]

    @usableFromInline
    init(object: JsonAny,
         properties: [Hitch]) {
        parent = object
        self.properties = properties
    }
}
