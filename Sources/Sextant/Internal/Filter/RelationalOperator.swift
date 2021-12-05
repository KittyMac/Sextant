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
//private let relationalOperatorMATCHES Hitch("MATCHES"))
private let relationalOperatorEMPTY = Hitch("EMPTY")
private let relationalOperatorSUBSETOF = Hitch("SUBSETOF")
private let relationalOperatorANYOF = Hitch("ANYOF")
private let relationalOperatorNONEOF = Hitch("NONEOF")

enum RelationalOperator: Hitch {
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
}

/*
#import "SMJRelationalOperator.h"


#pragma mark - SMJRelationalOperator

@implementation SMJRelationalOperator

#pragma mark - SMJRelationalOperator - Instance

+ (instancetype)instanceForOperator:(SMJRelationalOperatorIndex)operator
{
	dispatch_once(&(gOperators[operator].token), ^{
		gOperators[operator].value = (__bridge_retained void *)[[SMJRelationalOperator alloc] initWithOperatorString:(__bridge NSString *)(gOperators[operator].name)];
	});
	
	return (__bridge SMJRelationalOperator *)(gOperators[operator].value);
}

+ (instancetype)relationalOperatorEXISTS
{
	return [self instanceForOperator:SMJRelationalOperatorIndexEXISTS];
}

+ (nullable instancetype)relationalOperatorFromString:(NSString *)string error:(NSError **)error
{
	static dispatch_once_t		onceToken;
	static NSMutableDictionary	*map;
	
	dispatch_once(&onceToken, ^{
		
		map = [[NSMutableDictionary alloc] init];
		
		for (NSUInteger i = 0; i < sizeof(gOperators) / sizeof(gOperators[0]); i++)
		{
			NSString *name = (__bridge NSString *)(gOperators[i].name);
			
			map[name] = @(i);
		}
	});
	
	NSNumber *operator = map[string.uppercaseString];
	
	if (!operator)
	{
		if (error)
			*error = [NSError errorWithDomain:@"SMJRelationalOperatorErrorDomain" code:1 userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Filter operator %@ is not supported!", string] }];
		
		return nil;
	}
	
	return [self instanceForOperator:(SMJRelationalOperatorIndex)(operator.unsignedIntegerValue)];
	
}

- (instancetype)initWithOperatorString:(NSString *)operatorString
{
	self = [super init];
	
	if (self)
	{
		_stringOperator = [operatorString copy];
	}
	
	return self;
}

- (NSString *)getOperatorString
{
	return _stringOperator;
}

@end


NS_ASSUME_NONNULL_END
*/
