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

/*
#pragma mark - SMJRegexpEvaluatorTest

@interface SMJRegexpEvaluatorTest : SMJBaseTest
@end

@implementation SMJRegexpEvaluatorTest

- (void)checkRegexp:(NSString *)regexp valueNode:(SMJValueNode *)valueNode expectedResult:(BOOL)expectedResult
{
	NSError *error = nil;
	
	// > Operator.
	SMJRelationalOperator *operator = [SMJRelationalOperator relationalOperatorFromString:SMJRelationalOperatorREGEX error:&error];
	
	if (!operator)
	{
		XCTFail(@"can't create REGEXP operator: %@", error.localizedDescription);
		return;
	}
	
	// > Evaluator.
	id <SMJEvaluator> evaluator = [SMJEvaluatorFactory createEvaluatorForRelationalOperator:operator error:&error];
	
	if (!evaluator)
	{
		XCTFail(@"can't create evaluator: %@", error.localizedDescription);
		return;
	}
	
	// >
	id <SMJPredicateContext>	context = [self predicateContextForJsonObject:@{}];
	SMJValueNode				 *patternNode = [SMJValueNodes patternNodeWithString:regexp];

	SMJEvaluatorEvaluate evaluate = [evaluator evaluateLeftNode:patternNode rightNode:valueNode predicateContext:context error:&error];
	
	if (evaluate == SMJEvaluatorEvaluateError)
		XCTFail(@"evaluation error: %@", error.localizedDescription);
	else if (evaluate == SMJEvaluatorEvaluateTrue && expectedResult == NO)
		XCTFail(@"evaluation returned true while expected false");
	else if (evaluate == SMJEvaluatorEvaluateFalse && expectedResult == YES)
		XCTFail(@"evaluation returned false while expected true");
}

- (void)test_should_evaluate_regular_expression
{
	SMJRootPathToken	*rootPathToken = [[SMJRootPathToken alloc] initWithRootToken:'$'];
	SMJCompiledPath		*rootPath = [[SMJCompiledPath alloc] initWithRootPathToken:rootPathToken isRootPath:YES];
	
	[self checkRegexp:@"/true|false/" valueNode:[SMJValueNodes stringNodeWithString:@"true" escape:YES] expectedResult:YES];
	[self checkRegexp:@"/9.*9/" valueNode:[SMJValueNodes numberNodeWithString:@"9979"] expectedResult:YES];
	[self checkRegexp:@"/fa.*se/" valueNode:[SMJValueNodes booleanNodeWithString:@"false"] expectedResult:YES];
	[self checkRegexp:@"/JsonNode/" valueNode:[SMJValueNodes jsonNodeWithString:@"{ 'some': 'JsonNode' }"] expectedResult:NO];
	[self checkRegexp:@"/PathNode/" valueNode:[SMJValueNodes pathNodeWithPath:rootPath] expectedResult:NO];
	[self checkRegexp:@"/NullNode/" valueNode:[SMJValueNodes nullNode] expectedResult:NO];
	
	[self checkRegexp:@"/test/i" valueNode:[SMJValueNodes stringNodeWithString:@"tEsT" escape:YES] expectedResult:YES];
	[self checkRegexp:@"/test/" valueNode:[SMJValueNodes stringNodeWithString:@"tEsT" escape:YES] expectedResult:NO];
	[self checkRegexp:@"/\u00de/ui" valueNode:[SMJValueNodes stringNodeWithString:@"\u00fe" escape:YES] expectedResult:YES];
	
	// XXX we don't have this kind of unicode control on macOS (it's implicit and mandatory), so we can't test it's rejected without 'u' option.
	[self checkRegexp:@"/\u00de/" valueNode:[SMJValueNodes stringNodeWithString:@"\u00fe" escape:YES] expectedResult:NO];
	//[self checkRegexp:@"/\u00de/i" valueNode:[SMJValueNodes stringNodeWithString:@"\u00fe" escape:YES] expectedResult:NO];
	
	[self checkRegexp:@"/test# code/" valueNode:[SMJValueNodes stringNodeWithString:@"test" escape:YES] expectedResult:NO];
	[self checkRegexp:@"/test# code/x" valueNode:[SMJValueNodes stringNodeWithString:@"test" escape:YES] expectedResult:YES];
	
	// XXX test from json-path do :
	//  > "my\rtest" & "/.*test./d" -> true
	//  > "my\rtest" & "/.*test./" -> false
	// by default . doesn't match newline, so :
	//  > with 'd', . can match \r but not \n
	//  > without 'd', . can't match \r or \n
	// but the * mean 0 or more, so even if . doesn't match a newline, the * ignore it
	// the test are fixed by removing *
	[self checkRegexp:@"/.test./d" valueNode:[SMJValueNodes stringNodeWithString:@"my\rtest" escape:YES] expectedResult:YES];
	[self checkRegexp:@"/.test./" valueNode:[SMJValueNodes stringNodeWithString:@"my\rtest" escape:YES] expectedResult:NO];
	
	// XXX test from json-path do
	//  > "test\ntest" & "/.*tEst./is" -> true
	//  > "test\ntest" & "/.*tEst./i" -> false
	// the problem is the same than the previous one : even if . doesn't match a new line, the * ignore it.
	// the test are fixed by removing *
	[self checkRegexp:@"/.tEst./is" valueNode:[SMJValueNodes stringNodeWithString:@"test\ntest" escape:YES] expectedResult:YES];
	[self checkRegexp:@"/.tEst./i" valueNode:[SMJValueNodes stringNodeWithString:@"test\ntest" escape:YES] expectedResult:NO];
	
	// XXX we don't have this kind of unicode control on macOS (it's implicit and mandatory), so we can't test it's rejected without 'U' option.
	[self checkRegexp:@"/^\\w+$/U" valueNode:[SMJValueNodes stringNodeWithString:@"\u00fe" escape:YES] expectedResult:YES];
	//[self checkRegexp:@"/^\\w+$/" valueNode:[SMJValueNodes stringNodeWithString:@"\u00fe" escape:YES] expectedResult:NO];
	[self checkRegexp:@"/^test$\\ntest$/m" valueNode:[SMJValueNodes stringNodeWithString:@"test\ntest" escape:YES] expectedResult:YES];
}

@end


NS_ASSUME_NONNULL_END
*/
