import Foundation
import Hitch

final class ObjectPropertyPath: Path {
    let property: Hitch

    init(object: JsonAny,
         property: Hitch) {
        self.property = property
        super.init(parent: object)
    }
}
