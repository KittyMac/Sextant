import XCTest
import Hitch
import class Foundation.Bundle

@testable import Sextant

class ComplianceTest: TestsBase {
    
    func test_one() {
        let json = #"{"a":"a","b":"b","c d":"e"}"#
        
        XCTAssertEqualAny(json.query(values: "$.a"), ["a"])
        XCTAssertEqualAny(json.query(values: "$.*"), ["a","b","e"])
        XCTAssertEqualAny(json.query(values: "$[*]"), ["a","b","e"])
        XCTAssertEqualAny(json.query(values: "$['a']"), ["a"])
        XCTAssertEqualAny(json.query(values: "$.['c d']"), ["e"])
        XCTAssertEqualAny(json.query(values: "$[*]"), ["a","b","e"])
    }
    
    func test_two() {
        let json = #"[ 1, "2", 3.14, true, null ]"#
        
        XCTAssertEqualAny(json.query(values: "$[0]"), [1])
        XCTAssertEqualAny(json.query(values: "$[4]"), [nil])
        XCTAssertEqualAny(json.query(values: "$[*]"), [1, "2", 3.14, true, nil])
        XCTAssertEqualAny(json.query(values: "$[-1:]"), [nil])
    }
    
    func test_three() {
        let json = #"{"points":[{"id":"i1","x":4,"y":-5},{"id":"i2","x":-2,"y":2,"z":1},{"id":"i3","x":8,"y":3},{"id":"i4","x":-6,"y":-1},{"id":"i5","x":0,"y":2,"z":1},{"id":"i6","x":1,"y":4}]}"#
        
        XCTAssertEqualAny(json.query(values: "$.points[1]"), [["id":"i2","x":-2,"y":2,"z":1]])
        XCTAssertEqualAny(json.query(values: "$.points[4].x"), [0])
        XCTAssertEqualAny(json.query(values: "$.points[?(@.id == 'i4')].x"), [-6])
        XCTAssertEqualAny(json.query(values: "$.points[*].x"), [4,-2,8,-6,0,1])
        XCTAssertEqualAny(json.query(values: "$.points[?(@.z)].id"), ["i2","i5"])
    }
    
    func test_four() {
        let json = #"{"menu":{"header":"SVG Viewer","items":[{"id":"Open"},{"id":"OpenNew","label":"Open New"},null,{"id":"ZoomIn","label":"Zoom In"},{"id":"ZoomOut","label":"Zoom Out"},{"id":"OriginalView","label":"Original View"},null,{"id":"Quality"},{"id":"Pause"},{"id":"Mute"},null,{"id":"Find","label":"Find..."},{"id":"FindAgain","label":"Find Again"},{"id":"Copy"},{"id":"CopyAgain","label":"Copy Again"},{"id":"CopySVG","label":"Copy SVG"},{"id":"ViewSVG","label":"View SVG"},{"id":"ViewSource","label":"View Source"},{"id":"SaveAs","label":"Save As"},null,{"id":"Help"},{"id":"About","label":"About Adobe CVG Viewer..."}]}}"#
        
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@)]")?.count, 22)
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@.id == 'ViewSVG')].id"), ["ViewSVG"])
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@ && @.id == 'ViewSVG')].id"), ["ViewSVG"])
        XCTAssertEqualAny(json.query(values: "$.menu.items[?(@ && @.id && !@.label)].id"), ["Open","Quality","Pause","Mute","Copy","Help"])
    }
}


/*#pragma mark - SMJComplianceTest

@interface SMJComplianceTest : SMJBaseTest
@end

@implementation SMJComplianceTest

- (void)test_four
{

	[self checkResultForJSONString:json jsonPathString:@"$.menu.items[?(@)]" expectedError:NO];
	
	[self checkResultForJSONString:json jsonPathString:@"$.menu.items[?(@.id == 'ViewSVG')].id" expectedResult:@[ @"ViewSVG" ]];

	[self checkResultForJSONString:json jsonPathString:@"$.menu.items[?(@ && @.id == 'ViewSVG')].id" expectedResult:@[ @"ViewSVG" ]];

	[self checkResultForJSONString:json jsonPathString:@"$.menu.items[?(@ && @.id && !@.label)].id" expectedResult:@[ @"Open", @"Quality", @"Pause", @"Mute", @"Copy", @"Help" ]];
}

@end


NS_ASSUME_NONNULL_END
*/
