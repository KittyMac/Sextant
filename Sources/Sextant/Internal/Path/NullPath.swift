import Foundation
import Hitch

struct NullPath: Path {
    let parent: JsonAny = nil

    static let shared = NullPath()
}
