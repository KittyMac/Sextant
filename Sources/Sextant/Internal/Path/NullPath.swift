import Foundation
import Hitch

@usableFromInline
struct NullPath: Path {
    @usableFromInline
    let parent: JsonAny = nil

    @usableFromInline
    static let shared = NullPath()
}
