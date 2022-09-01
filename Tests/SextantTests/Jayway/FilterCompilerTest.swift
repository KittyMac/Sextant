import XCTest
import Hitch
import class Foundation.Bundle

#if DEBUG

@testable import Sextant

class FilterCompilerTest: TestsBase {

    func checkCompileJSONPathString(jsonPathString: Hitch, expectedError: Bool) {
        let filter = FilterCompiler.compile(filter: jsonPathString)
        
        if filter != nil && expectedError {
            XCTFail("got a filter while an error was expected");
        } else if filter == nil && !expectedError {
            XCTFail("got an error while a result was expected");
        }
    }

    func checkCompileJSONPathString(jsonPathString1: Hitch,
                                    jsonPathString2: Hitch) {
        guard let filter = FilterCompiler.compile(filter: jsonPathString1) else { return XCTFail("Failed to compile filter") }
        XCTAssertEqual(filter.description, jsonPathString2.description)
    }

    func test_valid_filters_compile() {
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['str_eq'] == '')]", jsonPathString2: "[?($['firstname']['str_eq'] == '')]")
        
        checkCompileJSONPathString(jsonPathString1: "[?(@)]", jsonPathString2: "[?(@)]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.firstname)]", jsonPathString2: "[?(@['firstname'])]")
        checkCompileJSONPathString(jsonPathString1: "[?($.firstname)]", jsonPathString2: "[?($['firstname'])]")
        checkCompileJSONPathString(jsonPathString1: "[?(@['firstname'])]", jsonPathString2: "[?(@['firstname'])]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname'].lastname)]", jsonPathString2: "[?($['firstname']['lastname'])]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['lastname'])]", jsonPathString2: "[?($['firstname']['lastname'])]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['lastname'].*)]", jsonPathString2: "[?($['firstname']['lastname'][*])]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['num_eq'] == 1)]", jsonPathString2: "[?($['firstname']['num_eq'] == 1)]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['num_gt'] > 1.1)]", jsonPathString2: "[?($['firstname']['num_gt'] > 1.1)]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['num_lt'] < 11.11)]", jsonPathString2: "[?($['firstname']['num_lt'] < 11.11)]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['str_eq'] == 'hej')]", jsonPathString2: "[?($['firstname']['str_eq'] == 'hej')]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['str_eq'] == '')]", jsonPathString2: "[?($['firstname']['str_eq'] == '')]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['str_eq'] == null)]", jsonPathString2: "[?($['firstname']['str_eq'] == null)]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['str_eq'] == true)]", jsonPathString2: "[?($['firstname']['str_eq'] == true)]")
        checkCompileJSONPathString(jsonPathString1: "[?($['firstname']['str_eq'] == false)]", jsonPathString2: "[?($['firstname']['str_eq'] == false)]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.firstname && @.lastname)]", jsonPathString2: "[?(@['firstname'] && @['lastname'])]")
        checkCompileJSONPathString(jsonPathString1: "[?((@.firstname || @.lastname) && @.and)]", jsonPathString2: "[?((@['firstname'] || @['lastname']) && @['and'])]")
        checkCompileJSONPathString(jsonPathString1: "[?((@.a || @.b || @.c) && @.x)]", jsonPathString2: "[?((@['a'] || @['b'] || @['c']) && @['x'])]")
        checkCompileJSONPathString(jsonPathString1: "[?((@.a && @.b && @.c) || @.x)]", jsonPathString2: "[?((@['a'] && @['b'] && @['c']) || @['x'])]")
        checkCompileJSONPathString(jsonPathString1: "[?((@.a && @.b || @.c) || @.x)]", jsonPathString2: "[?(((@['a'] && @['b']) || @['c']) || @['x'])]")
        checkCompileJSONPathString(jsonPathString1: "[?((@.a && @.b) || (@.c && @.d))]", jsonPathString2: "[?((@['a'] && @['b']) || (@['c'] && @['d']))]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.a IN [1,2,3])]", jsonPathString2: "[?(@['a'] IN [1,2,3])]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.a IN {'foo':'bar'})]", jsonPathString2: "[?(@['a'] IN {'foo':'bar'})]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.value<'7')]", jsonPathString2: "[?(@['value'] < '7')]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.message == 'it\\\\')]", jsonPathString2: "[?(@['message'] == 'it\\\\')]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.message.min() > 10)]", jsonPathString2: "[?(@['message'].min() > 10)]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.message.min()==10)]", jsonPathString2: "[?(@['message'].min() == 10)]")
        checkCompileJSONPathString(jsonPathString1: "[?(10 == @.message.min())]", jsonPathString2: "[?(10 == @['message'].min())]")
        checkCompileJSONPathString(jsonPathString1: "[?(((@)))]", jsonPathString2: "[?(@)]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.name =~ /.*?/i)]", jsonPathString2: "[?(@['name'] =~ /.*?/i)]")
        checkCompileJSONPathString(jsonPathString1: "[?(@.name =~ /.*?/)]", jsonPathString2: "[?(@['name'] =~ /.*?/)]")
        checkCompileJSONPathString(jsonPathString1: "[?($[\"firstname\"][\"lastname\"])]", jsonPathString2: "[?($[\"firstname\"][\"lastname\"])]")
        checkCompileJSONPathString(jsonPathString1: "[?($[\"firstname\"].lastname)]", jsonPathString2: "[?($[\"firstname\"]['lastname'])]")
        checkCompileJSONPathString(jsonPathString1: "[?($[\"firstname\", \"lastname\"])]", jsonPathString2: "[?($[\"firstname\",\"lastname\"])]")
        checkCompileJSONPathString(jsonPathString1: "[?(((@.a && @.b || @.c)) || @.x)]", jsonPathString2: "[?(((@['a'] && @['b']) || @['c']) || @['x'])]")
    }

    func test_string_quote_style_is_serialized() {
        checkCompileJSONPathString(jsonPathString1: "[?('apa' == 'apa')]", jsonPathString2: "[?('apa' == 'apa')]")
        checkCompileJSONPathString(jsonPathString1: "[?('apa' == \"apa\")]", jsonPathString2: "[?('apa' == \"apa\")]")
    }

    func test_string_can_contain_path_chars() {
        checkCompileJSONPathString(jsonPathString1: "[?(@[')]@$)]'] == ')]@$)]')]", jsonPathString2: "[?(@[')]@$)]'] == ')]@$)]')]")
        checkCompileJSONPathString(jsonPathString1: "[?(@[\")]@$)]\"] == \")]@$)]\")]", jsonPathString2: "[?(@[\")]@$)]\"] == \")]@$)]\")]")
    }

    func test_invalid_path_when_string_literal_is_unquoted() {
        checkCompileJSONPathString(jsonPathString: "[?(@.foo == x)]", expectedError: true)
    }

    func test_or_has_lower_priority_than_and() {
        checkCompileJSONPathString(jsonPathString1: "[?(@.category == 'fiction' && @.author == 'Evelyn Waugh' || @.price > 15)]",
                                   jsonPathString2: "[?((@['category'] == 'fiction' && @['author'] == 'Evelyn Waugh') || @['price'] > 15)]")
    }

    func test_invalid_filters_does_not_compile() {
        checkCompileJSONPathString(jsonPathString: "[?(@))]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(@ FOO 1)]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(@ || )]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(@ == 'foo )]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(@ == 1' )]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(@.foo bar == 1)]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(@.i == 5 @.i == 8)]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(!5)]", expectedError: true)
        checkCompileJSONPathString(jsonPathString: "[?(!'foo')]", expectedError: true)
    }

    func test_not_exists_filter() {
        checkCompileJSONPathString(jsonPathString1: "[?(!@.foo)]", jsonPathString2: "[?(!@['foo'])]")
    }

}

extension FilterCompilerTest {
    static var allTests : [(String, (FilterCompilerTest) -> () throws -> Void)] {
        return [
            ("test_valid_filters_compile", test_valid_filters_compile),
            ("test_string_quote_style_is_serialized", test_string_quote_style_is_serialized),
            ("test_string_can_contain_path_chars", test_string_can_contain_path_chars),
            ("test_invalid_path_when_string_literal_is_unquoted", test_invalid_path_when_string_literal_is_unquoted),
            ("test_or_has_lower_priority_than_and", test_or_has_lower_priority_than_and),
            ("test_invalid_filters_does_not_compile", test_invalid_filters_does_not_compile),
            ("test_not_exists_filter", test_not_exists_filter),
        ]
    }
}

#endif
