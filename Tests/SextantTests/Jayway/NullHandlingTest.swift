import XCTest
import class Foundation.Bundle

@testable import Sextant

class NullHandlingTest: TestsBase {
    let jsonDocumentNull = """
        {
            "root-property": "root-property-value",
            "root-property-null": null,
            "children": [
                {
                    "id": 0,
                    "name": "name-0",
                    "age": 0
                },
                {
                    "id": 1,
                    "name": "name-1",
                    "age": null
                },
                {
                    "id": 3,
                    "name": "name-3"
                }
            ]
        }
    """
    
    func test_not_defined_property_throws_PathNotFoundException() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[0].child.age"), nil)
    }
    
    func test_last_token_defaults_to_null() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[2].age"), nil)
    }
    
    func test_null_property_returns_null() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[0].age"), [0])
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[1].age"), [nil])
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[2].age"), nil)
    }
    
    func test_the_age_of_all_with_age_defined() {
        XCTAssertEqualAny(jsonDocumentNull.query(values: "$.children[*].age"), [0, nil])
    }
}
/*
- (void)test_the_age_of_all_with_age_defined
{
	[self checkResultForJSONString:_jsonDocument jsonPathString:@"$.children[*].age" expectedResult:@[ @0, [NSNull null]]];
}

- (void)test_path2
{
	[self checkResultForJSONString:@"{\"a\":[{\"b\":1,\"c\":2},{\"b\":5,\"c\":2}]}" jsonPathString:@"a[?(@.b==4)].c" expectedResult:@[]];
}

- (void)test_path
{
	[self checkResultForJSONString:@"{\"a\":[{\"b\":1,\"c\":2},{\"b\":5,\"c\":2}]}"
					jsonPathString:@"a[?(@.b==5)].d"
					 configuration:[SMJConfiguration configurationWithOption:SMJOptionDefaultPathLeafToNull]
					expectedResult:@[ [NSNull null] ]];
}

@end


NS_ASSUME_NONNULL_END
*/
