import XCTest
import class Foundation.Bundle
import Hitch

@testable import Sextant

class RegexEvaluatorTest: TestsBase {
    
    func checkRegex(regex: Hitch, valueNode: ValueNode, result expected: Bool) {        
        guard let evaluator = Evaluator(relationalOperator: .REGEX) else {
            XCTFail("Cannot create REGEX evaluator")
            return
        }
        
        let context = PredicateContext(jsonObject: [:],
                                       rootJsonObject: [:],
                                       pathCache: [:])
        
        let patternNode = PatternNode(regex: regex)
        
        let result = evaluator.evaluate(left: patternNode, right: valueNode, context: context)
        
        if result == .error {
            XCTFail("evaluation error")
        } else if result == .true && expected == false {
            XCTFail("evaluation returned true while expected false")
        } else if result == .false && expected == true {
            XCTFail("evaluation returned false while expected true")
        }
    }
    
    func test_should_evaluate_regular_expression() {
        let rootPathToken = RootPathToken(root: .dollarSign)
        let rootPath = CompiledPath(root: rootPathToken, isRootPath: true)
        
        checkRegex(regex: "/true|false/", valueNode: StringNode(hitch: "true", escape: true), result: true)
        checkRegex(regex: "/9.*9/", valueNode: NumberNode(hitch: "9979"), result: true)
        checkRegex(regex: "/fa.*se/", valueNode: BooleanNode(hitch: "false"), result: true)
        
        checkRegex(regex: "/JsonNode/", valueNode: JsonNode(hitch: "{ 'some': 'JsonNode' }"), result: true)
        checkRegex(regex: "/PathNode/", valueNode: PathNode(prebuiltPath: rootPath), result: false)
        checkRegex(regex: "/NullNode/", valueNode: NullNode(), result: false)
        
        checkRegex(regex: "/test/i", valueNode: StringNode(hitch: "tEsT", escape: true), result: true)
        checkRegex(regex: "/test/", valueNode: StringNode(hitch: "tEsT", escape: true), result: false)
        
        checkRegex(regex: #"/\u00de/ui"#, valueNode: StringNode(hitch: #"\u00fe"#, escape: true), result: true)
        checkRegex(regex: #"/\u00de/"#, valueNode: StringNode(hitch: #"\u00fe"#, escape: true), result: false)
        
        checkRegex(regex: "/test# code/", valueNode: StringNode(hitch: "test", escape: true), result: false)
        checkRegex(regex: "/test# code/x", valueNode: StringNode(hitch: "test", escape: true), result: true)
    }
}

extension RegexEvaluatorTest {
    static var allTests : [(String, (RegexEvaluatorTest) -> () throws -> Void)] {
        return [
            ("test_should_evaluate_regular_expression", test_should_evaluate_regular_expression)
        ]
    }
}
