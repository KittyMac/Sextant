import Foundation
import Hitch

@usableFromInline
struct RootPath: Path {
    @usableFromInline
    var parent: JsonAny

    @usableFromInline
    init(rootObject: JsonAny) {
        parent = rootObject
    }
}
