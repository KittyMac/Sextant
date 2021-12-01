import Foundation
import Hitch

final class NullPath: Path {
    static let shared = NullPath()
    private init() { super.init(parent: nil) }
}
