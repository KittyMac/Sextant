import Foundation
import Hitch

private let relationalOperatorGTE = Hitch(">=")
private let relationalOperatorLTE = Hitch("<=")
private let relationalOperatorEQ = Hitch("==")

private let relationalOperatorTSEQ = Hitch("===")
private let relationalOperatorNE = Hitch("!=")

private let relationalOperatorTSNE = Hitch("!==")
private let relationalOperatorLT = Hitch("<")
private let relationalOperatorGT = Hitch(">")
private let relationalOperatorREGEX = Hitch("=~")
private let relationalOperatorNIN = Hitch("NIN")
private let relationalOperatorIN = Hitch("IN")
private let relationalOperatorCONTAINS = Hitch("CONTAINS")
private let relationalOperatorALL = Hitch("ALL")
private let relationalOperatorSIZE = Hitch("SIZE")
private let relationalOperatorEXISTS = Hitch("EXISTS")
private let relationalOperatorTYPE = Hitch("TYPE")
//private let relationalOperatorMATCHES Hitch("matches"))
private let relationalOperatorEMPTY = Hitch("EMPTY")
private let relationalOperatorSUBSETOF = Hitch("SUBSETOF")
private let relationalOperatorANYOF = Hitch("ANYOF")
private let relationalOperatorNONEOF = Hitch("NONEOF")

enum RelationalOperator {
    case GTE
    case LTE
    case EQ

    case TSEQ
    case NE
    
    case TSNE
    case LT
    case GT
    case REGEX
    case NIN
    case IN
    case CONTAINS
    case ALL
    case SIZE
    case EXISTS
    case TYPE
    //case MATCHES
    case EMPTY
    case SUBSETOF
    
    case ANYOF
    case NONEOF
    
    func hitch() -> Hitch {
        switch self {
        case .GTE:
            return relationalOperatorGTE
        case .LTE:
            return relationalOperatorLTE
        case .EQ:
            return relationalOperatorEQ
        case .TSEQ:
            return relationalOperatorTSEQ
        case .NE:
            return relationalOperatorNE
        case .TSNE:
            return relationalOperatorTSNE
        case .LT:
            return relationalOperatorLT
        case .GT:
            return relationalOperatorGT
        case .REGEX:
            return relationalOperatorREGEX
        case .NIN:
            return relationalOperatorNIN
        case .IN:
            return relationalOperatorIN
        case .CONTAINS:
            return relationalOperatorCONTAINS
        case .ALL:
            return relationalOperatorALL
        case .SIZE:
            return relationalOperatorSIZE
        case .EXISTS:
            return relationalOperatorEXISTS
        case .TYPE:
            return relationalOperatorTYPE
        case .EMPTY:
            return relationalOperatorEMPTY
        case .SUBSETOF:
            return relationalOperatorSUBSETOF
        case .ANYOF:
            return relationalOperatorANYOF
        case .NONEOF:
            return relationalOperatorNONEOF
        }
    }

    init?(hitch: Hitch) {
        switch hitch.uppercase() {
        case relationalOperatorGTE:
            self = .GTE
        case relationalOperatorLTE:
            self = .LTE
        case relationalOperatorEQ:
            self = .EQ
        case relationalOperatorTSEQ:
            self = .TSEQ
        case relationalOperatorNE:
            self = .NE
        case relationalOperatorTSNE:
            self = .TSNE
        case relationalOperatorLT:
            self = .LT
        case relationalOperatorGT:
            self = .GT
        case relationalOperatorREGEX:
            self = .REGEX
        case relationalOperatorNIN:
            self = .NIN
        case relationalOperatorIN:
            self = .IN
        case relationalOperatorCONTAINS:
            self = .CONTAINS
        case relationalOperatorALL:
            self = .ALL
        case relationalOperatorSIZE:
            self = .SIZE
        case relationalOperatorEXISTS:
            self = .EXISTS
        case relationalOperatorTYPE:
            self = .TYPE
        case relationalOperatorEMPTY:
            self = .EMPTY
        case relationalOperatorSUBSETOF:
            self = .SUBSETOF
        case relationalOperatorANYOF:
            self = .ANYOF
        case relationalOperatorNONEOF:
            self = .NONEOF
        default:
            return nil
        }
    }
}
