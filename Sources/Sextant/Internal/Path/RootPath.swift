import Foundation
import Hitch

final class RootPath: Path {

    init(rootObject: JsonAny) {
        super.init(parent: rootObject)
    }
}
