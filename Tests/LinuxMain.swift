import XCTest

@testable import SextantTests

XCTMain([
    testCase(ArrayIndexFilterTest.allTests),
    testCase(ArrayPathTokenTest.allTests),
    testCase(ArraySlicingTest.allTests),
    testCase(ComplianceTest.allTests),
    testCase(DeepScanTest.allTests),
    testCase(ExamplesTest.allTests),
    testCase(FilterCompilerTest.allTests),
    testCase(FilterParseTest.allTests),
    testCase(FilterTest.allTests),
    testCase(InlineFilterTest.allTests),
    testCase(JSONEntityPathFunctionTest.allTests),
    testCase(JsonPathTest.allTests),
    testCase(MultiPropTest.allTests),
    testCase(NestedFunctionTest.allTests),
    testCase(NullHandlingTest.allTests),
    testCase(NumericPathFunctionTest.allTests),
    testCase(PathCompilerTest.allTests),
    testCase(PathTokenTest.allTests),
    testCase(PatternFlagTest.allTests),
    testCase(PredicatePathTokenTests.allTests),
    testCase(PropertyPathTokenTests.allTests),
    testCase(RegexEvaluatorTest.allTests),
    testCase(ReturnTypeTests.allTests),
    testCase(ScanPathTokenTests.allTests)
])
