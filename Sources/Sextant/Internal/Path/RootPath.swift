import Foundation
import Hitch

struct RootPath: Path {
    var parent: JsonAny

    init(rootObject: JsonAny) {
        parent = rootObject
    }
}
