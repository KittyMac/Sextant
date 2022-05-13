import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class PathTokenTest: TestsBase {
    
    func makePathReturningTail(tokens: [PathToken]) -> PathToken? {
        var last: PathToken? = nil
        
        for token in tokens {
            if let last = last {
                last.append(tail: token)
            }
            last = token
        }

        return last
    }
    
    func makePTT(_ properties: Hitch...) -> PropertyPathToken {
        return PropertyPathToken(properties: properties,
                                 wrap: .singleQuote)!
    }
    
    func test_is_upstream_definite_in_simple_case() {
        XCTAssertTrue(makePathReturningTail(tokens: [makePTT("foo")
        ])?.isUpstreamDefinite() ?? false)
        
        XCTAssertTrue(makePathReturningTail(tokens: [makePTT("foo", "foo2"), makePTT("bar")
        ])?.isUpstreamDefinite() ?? false)
        
        XCTAssertTrue(makePathReturningTail(tokens: [WildcardPathToken(), makePTT("bar")
        ])?.isUpstreamDefinite() ?? false)
        
        XCTAssertTrue(makePathReturningTail(tokens: [ScanPathToken(), makePTT("bar")
        ])?.isUpstreamDefinite() ?? false)
    }
    
    func test_is_upstream_definite_in_complex_case() {
        XCTAssertTrue(makePathReturningTail(tokens: [makePTT("foo"), makePTT("bar"), makePTT("baz")
        ])?.isUpstreamDefinite() ?? false)
        
        
        XCTAssertTrue(makePathReturningTail(tokens: [makePTT("foo"), WildcardPathToken()
        ])?.isUpstreamDefinite() ?? false)
        
        XCTAssertTrue(makePathReturningTail(tokens: [WildcardPathToken(), makePTT("bar"), makePTT("baz")
        ])?.isUpstreamDefinite() ?? false)
    }
}

extension PathTokenTest {
    static var allTests : [(String, (PathTokenTest) -> () throws -> Void)] {
        return [
            ("test_is_upstream_definite_in_simple_case", test_is_upstream_definite_in_simple_case),
            ("test_is_upstream_definite_in_complex_case", test_is_upstream_definite_in_complex_case),
        ]
    }
}
