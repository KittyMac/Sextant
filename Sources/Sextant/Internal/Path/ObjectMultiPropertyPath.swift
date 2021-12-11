import Foundation
import Hitch

struct ObjectMultiPropertyPath: Path {
    let parent: JsonAny
    let properties: [Hitch]

    init(object: JsonAny,
         properties: [Hitch]) {
        parent = object
        self.properties = properties
    }
}
