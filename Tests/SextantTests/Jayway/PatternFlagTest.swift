import XCTest
import class Foundation.Bundle
import Hitch

@testable import Sextant

class PatternFlagTest: TestsBase {
    private func RegexFlags(_ f: NSRegularExpression.Options) -> NSRegularExpression.Options {
        return f
    }
    
    func testParseFlags() {
        XCTAssertEqual(PatternFlags("d"), RegexFlags([.useUnixLineSeparators]))
        XCTAssertEqual(PatternFlags("i"), RegexFlags([.caseInsensitive]))
        XCTAssertEqual(PatternFlags("x"), RegexFlags([.allowCommentsAndWhitespace]))
        XCTAssertEqual(PatternFlags("m"), RegexFlags([.anchorsMatchLines]))
        XCTAssertEqual(PatternFlags("xmsU"), RegexFlags([.allowCommentsAndWhitespace, .anchorsMatchLines, .dotMatchesLineSeparators]))
        XCTAssertEqual(PatternFlags("dxm"), RegexFlags([.useUnixLineSeparators, .allowCommentsAndWhitespace, .anchorsMatchLines]))
        XCTAssertEqual(PatternFlags("dix"), RegexFlags([.useUnixLineSeparators, .caseInsensitive, .allowCommentsAndWhitespace]))
        XCTAssertEqual(PatternFlags("xsu"), RegexFlags([.allowCommentsAndWhitespace, .dotMatchesLineSeparators]))
        XCTAssertEqual(PatternFlags("dixmsuU"), RegexFlags([.useUnixLineSeparators, .caseInsensitive, .allowCommentsAndWhitespace, .anchorsMatchLines, .dotMatchesLineSeparators]))
    }
}

extension PatternFlagTest {
    static var allTests : [(String, (PatternFlagTest) -> () throws -> Void)] {
        return [
            ("testParseFlags", testParseFlags),
        ]
    }
}
