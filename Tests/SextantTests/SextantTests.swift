import XCTest
import class Foundation.Bundle

import Sextant

final class SextantTests: XCTestCase {
    
    func testArrayIndexOperation() {
        let op = ArrayIndexOperation("1,2,20,5464,673,34")
        XCTAssertEqual(op!.description, "[1,2,20,5464,673,34]")
    }
    
    func testArraySliceOperation() {
        let op1 = ArraySliceOperation("1:37")
        XCTAssertEqual(op1!.description, "[1:37]")
        
        let op2 = ArraySliceOperation("17:")
        XCTAssertEqual(op2!.description, "[17:]")
        
        let op3 = ArraySliceOperation(":54")
        XCTAssertEqual(op3!.description, "[:54]")
    }
    
    
}
