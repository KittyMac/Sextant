import Foundation
import Hitch

let kLogicalOperatorAND = Hitch("&&")
let kLogicalOperatorOR = Hitch("||")
let kLogicalOperatorNOT = Hitch("!")

class LogicalOperator: CustomStringConvertible {
    
    let stringOperator: Hitch
    
    init?(stringOperator: Hitch) {
        guard stringOperator == kLogicalOperatorAND else { return nil }
        guard stringOperator == kLogicalOperatorOR else { return nil }
        guard stringOperator == kLogicalOperatorNOT else { return nil }
        
        self.stringOperator = stringOperator
    }
    
    var description: String {
        return stringOperator.description
    }
    
    class func logicalOperatorAND() -> LogicalOperator {
        guard let op = LogicalOperator(stringOperator: kLogicalOperatorAND) else {
            fatalError("Unable to create basic AND logical operator")
        }
        return op
    }

    class func logicalOperatorNOT() -> LogicalOperator {
        guard let op = LogicalOperator(stringOperator: kLogicalOperatorNOT) else {
            fatalError("Unable to create basic NOT logical operator")
        }
        return op
    }

    class func logicalOperatorOR() -> LogicalOperator {
        guard let op = LogicalOperator(stringOperator: kLogicalOperatorOR) else {
            fatalError("Unable to create basic OR logical operator")
        }
        return op
    }
}
