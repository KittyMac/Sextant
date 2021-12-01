import Foundation
import Hitch

final class ObjectMultiPropertyPath: Path {
    let properties: [Hitch]
    
    init(object: JsonAny,
         properties: [Hitch]) {
        self.properties = properties
        super.init(parent: object)
    }
}
