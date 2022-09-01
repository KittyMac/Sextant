import XCTest
import Hitch
import class Foundation.Bundle

#if DEBUG

@testable import Sextant

class FilterParseTest: TestsBase {

    func checkCompileJSONPathString(jsonPathString: Hitch, expectedError: Bool) {
        let filter = FilterCompiler.compile(filter: jsonPathString)
        
        if filter != nil && expectedError {
            XCTFail("got a filter while an error was expected");
        } else if filter == nil && !expectedError {
            XCTFail("got an error while a result was expected");
        }
    }

    func test_a_filter_can_be_parsed() {
        checkCompileJSONPathString(jsonPathString: "[?(@.foo)]", expectedError: false)
        checkCompileJSONPathString(jsonPathString: "[?(@.foo == 1)]", expectedError: false)
        checkCompileJSONPathString(jsonPathString: "[?(@.foo == 1 || @['bar'])]", expectedError: false)
        checkCompileJSONPathString(jsonPathString: "[?(@.foo == 1 && @['bar'])]", expectedError: false)
    }

    func test_an_invalid_filter_can_not_be_parsed() {
        checkCompileJSONPathString(jsonPathString: "[?(@.foo == 1)", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(@.foo == 1) ||]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[(@.foo == 1)]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?@.foo == 1)]", expectedError: true)
    }

}

extension FilterParseTest {
    static var allTests : [(String, (FilterParseTest) -> () throws -> Void)] {
        return [
            ("test_a_filter_can_be_parsed", test_a_filter_can_be_parsed),
            ("test_an_invalid_filter_can_not_be_parsed", test_an_invalid_filter_can_not_be_parsed),
        ]
    }
}

#endif
