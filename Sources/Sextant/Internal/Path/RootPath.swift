import Foundation
import Hitch

@usableFromInline
struct RootPath: Path {
    @usableFromInline
    var parent: JsonAny

    @usableFromInline
    var options: EvaluationOptions

    @usableFromInline
    init(rootObject: JsonAny,
         options: EvaluationOptions) {
        parent = rootObject
        self.options = options
    }
}
