import Foundation
import Hitch

fileprivate let kDocContextChar = UInt8.dollarSign
fileprivate let kEvalContextChar = UInt8.atMark

fileprivate let kOpenSquareBracketChar = UInt8.openBrace
fileprivate let kCloseSquareBracketChar = UInt8.closeBrace
fileprivate let kOpenParenthesisChar = UInt8.parenOpen
fileprivate let kCloseParenthesisChar = UInt8.parenClose
fileprivate let kOpenObjectChar = UInt8.openBracket
fileprivate let kCloseObjectChar = UInt8.closeBracket
fileprivate let kOpenArrayChar = UInt8.openBrace
fileprivate let kCloseArrayChar = UInt8.closeBrace

fileprivate let kSingleQuoteChar = UInt8.singleQuote
fileprivate let kDoubleQuoteChar = UInt8.doubleQuote

fileprivate let kSpaceChar = UInt8.space
fileprivate let kPeriodChar = UInt8.dot

fileprivate let kAndChar = UInt8.ampersand
fileprivate let kOrChar = UInt8.pipe

fileprivate let kMinusChar = UInt8.minus
fileprivate let kLessThanChar = UInt8.lessThan
fileprivate let kGreaterThanChar = UInt8.greaterThan
fileprivate let kEqualChar = UInt8.equal
fileprivate let kTildeChar = UInt8.tilde
fileprivate let kTrueChar = UInt8.t
fileprivate let kFalseChar = UInt8.f
fileprivate let kNullChar = UInt8.n
fileprivate let kNotChar = UInt8.bang
fileprivate let kPatternChar = UInt8.forwardSlash
fileprivate let kIgnoreCaseChar = UInt8.i

fileprivate let nullHitch = Hitch("null")
fileprivate let trueHitch = Hitch("true")
fileprivate let falseHitch = Hitch("false")

final class FilterCompiler {
    var filter: CharacterIndex
    
    init?(filter filterString: Hitch) {
        filter = CharacterIndex(query: filterString)
        filter.trim()
        
        guard filter.current() == .openBrace && filter.last() == .closeBrace else {
            error("Filter must start with '[' and end with ']'. \(filter)")
            return nil
        }
        
        filter.advance(1)
        filter.removeFromEnd(1)
        filter.trim()
        
        guard filter.current() == .questionMark else {
            error("Filter must start with '[?' and end with ']'. \(filter)")
            return nil
        }
        
        filter.advance(1)
        filter.trim()
        
        guard filter.current() == .parenOpen || filter.last() == .parenClose else {
            error("Filter must start with '[?(' and end with ')]'. \(filter)")
            return nil
        }
    }
    
    class func compile(filter: Hitch) -> Predicate? {
        return FilterCompiler(filter: filter)?.compile()
    }
    
    func compile() -> Predicate? {
        guard let result = readLogicalOR() else { return nil }
        
        filter.skipBlanks()
        
        if filter.inBounds() {
            error("Expected end of filter expression instead of: \(filter)")
            return nil
        }
        
        return result
    }
    
    func readLogicalOR() -> ExpressionNode? {
        var ops = [ExpressionNode]()
        
        guard let logicalAND = readLogicalAND() else { return nil }
        
        ops.append(logicalAND)
        
        while true {
            let savepoint = filter.position
            if filter.hasSignificantString(string: kLogicalOperatorOR) == false {
                filter.position = savepoint
                break
            }
            
            guard let logicalAND = readLogicalANDOperand() else {
                filter.position = savepoint
                break
            }
            
            ops.append(logicalAND)
        }
        
        return ops.count == 1 ? ops.first : LogicalExpressionNode.logicalOr(nodes: ops)
    }
    
    func readLogicalAND() -> ExpressionNode? {
        var ops = [ExpressionNode]()
        
        guard let logicalAND = readLogicalANDOperand() else { return nil }
        
        ops.append(logicalAND)
        
        while true {
            let savepoint = filter.position
            if filter.hasSignificantString(string: kLogicalOperatorAND) == false {
                filter.position = savepoint
                break
            }
            
            guard let logicalAND = readLogicalANDOperand() else {
                filter.position = savepoint
                break
            }
            
            ops.append(logicalAND)
        }
        
        return ops.count == 1 ? ops.first : LogicalExpressionNode.logicalAnd(nodes: ops)
    }
    
    func readLogicalANDOperand() -> ExpressionNode? {
        let savepoint = filter.skipBlanks().position
        
        if filter.skipBlanks().current() == kNotChar {
            guard filter.readSignificantCharacter(character: kNotChar) else { return nil }
            
            switch filter.skipBlanks().current() {
            case kDocContextChar, kEvalContextChar:
                filter.position = savepoint
                break
            default:
                guard let op = readLogicalANDOperand() else { return nil }
                return LogicalExpressionNode.logicalNot(node: op)
            }
        }
        
        if filter.skipBlanks().current() == kOpenParenthesisChar {
            guard filter.readSignificantCharacter(character: kOpenParenthesisChar) else { return nil }
            guard let op = readLogicalOR() else { return nil }
            guard filter.readSignificantCharacter(character: kCloseParenthesisChar) else { return nil }
            return op
        }
        
        return readExpression()
    }
    
    func readExpression() -> RelationalExpressionNode? {
        guard let left = readValueNode() else { return nil }
        
        let savepoint = filter.position
        
        let relationalOperator = readRelationalOperator()
        if let relationalOperator = relationalOperator,
           let right = readValueNode() {
            return RelationalExpressionNode(left: left,
                                            relationalOperator: relationalOperator,
                                            right: right)
        }
        
        filter.position = savepoint
        
        guard let pathNode = left as? PathNode else {
            error("path node expected")
            return nil
        }
        
        return RelationalExpressionNode(left: pathNode,
                                        relationalOperator: .EXISTS,
                                        right: pathNode.shouldExists ? BooleanNode.true : BooleanNode.false)
    }
    
    func readRelationalOperator() -> RelationalOperator? {
        let begin = filter.skipBlanks().position
        
        if isRelationalOperatorChar(filter.current()) {
            while filter.inBounds() && isRelationalOperatorChar(filter.current()) {
                filter.advance(1)
            }
        } else {
            while filter.inBounds() && filter.current() != .space {
                filter.advance(1)
            }
        }
        
        guard let relationalOperator = filter.substring(begin, filter.position) else { return nil }
        return RelationalOperator(hitch: relationalOperator)
    }
    
    func readValueNode() -> ValueNode? {
        switch filter.skipBlanks().current() {
        case kDocContextChar, kEvalContextChar:
            return readPath()
        case kNotChar:
            filter.advance(1)
            switch filter.skipBlanks().current() {
            case kDocContextChar, kEvalContextChar:
                return readPath()
            default:
                error("Unexpected character '\(kNotChar)'")
                return nil
            }
        default:
            return readLiteral()
        }
    }
    
    func readLiteral() -> ValueNode? {
        switch filter.skipBlanks().current() {
            case kSingleQuoteChar:
                return readStringLiteral(endChar: kSingleQuoteChar)
            case kDoubleQuoteChar:
                return readStringLiteral(endChar: kDoubleQuoteChar)
            case kTrueChar:
                return readBooleanLiteral()
            case kFalseChar:
                return readBooleanLiteral()
            case kMinusChar:
                return readNumberLiteral()
            case kNullChar:
                return readNullLiteral()
            case kOpenObjectChar:
                return readJsonLiteral()
            case kOpenArrayChar:
                return readJsonLiteral()
            case kPatternChar:
                return readPatternLiteral()
            default:
                return readNumberLiteral()
        }
    }
    
    func readNullLiteral() -> NullNode? {
        if filter.current() == kNullChar && filter.compareAndAdvance(hitch: nullHitch) {
            return NullNode()
        }
        error("Expected <null> value")
        return nil
    }
    
    func readJsonLiteral() -> JsonNode? {
        let begin = filter.position
        
        let openChar = filter.current()
        
        if openChar != kOpenArrayChar && openChar != kOpenObjectChar {
            error("internal error")
            return nil
        }
        
        let closeChar = openChar == kOpenArrayChar ? kCloseArrayChar : kCloseObjectChar
        
        let closingIndex = filter.indexOfMatchingCloseCharacter(index: filter.position,
                                                                openChar: openChar,
                                                                closeChar: closeChar,
                                                                skipStrings: true,
                                                                skipRegex: false)
        if closingIndex < 0 {
            error("String not closed. Expected \(kSingleQuoteChar) in \(filter)")
            return nil
        }
        
        filter.position = closingIndex + 1
        
        guard let json = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }
        
        return JsonNode(hitch: json)
    }
    
    func readPatternLiteral() -> PatternNode? {
        let begin = filter.position
        var closingIndex = filter.nextIndexOfUnescapedCharacter(character: kPatternChar)
        
        guard closingIndex >= 0 else {
            error("Pattern not closed. Expected \(kPatternChar) in \(filter)")
            return nil
        }
        
        if filter.inBounds(position: closingIndex + 1) {
            let equalSignIndex = filter.nextIndexOfCharacter(character: .equal)
            let endIndex = equalSignIndex >= 0 ? equalSignIndex : filter.nextIndexOfUnescapedCharacter(character: kCloseParenthesisChar)
            if let flags = filter.substring(closingIndex + 1, endIndex) {
                closingIndex += flags.count
            }
        }
        filter.position = closingIndex + 1
        
        guard let pattern = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }
        return PatternNode(regex: pattern)
    }
    
    func readStringLiteral(endChar: UInt8) -> StringNode? {
        let begin = filter.position
        let closingSingleQuoteIndex = filter.nextIndexOfUnescapedCharacter(character: endChar)
        
        guard closingSingleQuoteIndex >= 0 else {
            error("String literal does not have matching quotes. Expected \(endChar) in \(filter)")
            return nil
        }
        
        filter.position = closingSingleQuoteIndex + 1
        
        guard let stringLiteral = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }
        
        return StringNode(hitch: stringLiteral, escape: true)
    }
    
    func readNumberLiteral() -> NumberNode? {
        let begin = filter.position
        while filter.inBounds() && filter.isNumberCharacter(index: filter.position) {
            filter.advance(1)
        }
        guard let numberLiteral = filter.substring(begin, filter.position) else {
            error("internal error")
            return nil
        }
        return NumberNode(hitch: numberLiteral)
    }

    func readBooleanLiteral() -> BooleanNode? {
        if filter.compareAndAdvance(hitch: trueHitch) {
            return BooleanNode.true
        }
        if filter.compareAndAdvance(hitch: falseHitch) {
            return BooleanNode.false
        }
        error("Expected boolean literal")
        return nil
    }
    
    func readPath() -> PathNode? {
        let previousSignificantChar = filter.previousSignificantCharacter()
        let begin = filter.position
        
        filter.advance(1) //skip $ and @
        
        while filter.inBounds() {
            if filter.current() == .openBrace {
                let closingSquareBracketIndex = filter.indexOfMatchingCloseCharacter(index: filter.position,
                                                                                     openChar: .openBrace,
                                                                                     closeChar: .closeBrace,
                                                                                     skipStrings: true,
                                                                                     skipRegex: false)
                
                guard closingSquareBracketIndex >= 0 else {
                    error("Square brackets does not match in filter \(filter)")
                    return nil
                }
                
                filter.position = closingSquareBracketIndex + 1
            }
        
        
            let closingFunctionBracket = filter.current() == .parenClose && currentCharIsClosingFunctionBracket(lowerBound: begin)
            let closingLogicalBracket = filter.current() == .parenClose && !closingFunctionBracket
            
            if filter.inBounds() == false || isRelationalOperatorChar(filter.current()) || filter.current() == .space || closingLogicalBracket {
                break
            }
            
            filter.advance(1)
        }
        
        let shouldExists = previousSignificantChar != kNotChar
        guard let pathString = filter.substring(begin, filter.position) else {
            return nil
        }
        
        return PathNode(path: pathString,
                        existsCheck: false,
                        shouldExists: shouldExists)
    }
    
    func currentCharIsClosingFunctionBracket(lowerBound: Int) -> Bool {
        if filter.current() != .parenClose {
            return false
        }
        
        var idx = filter.indexOfPreviousSignificantCharacter()
        if idx == -1 || filter[idx] != .parenOpen {
            return false
        }
        
        idx -= 1
        
        while filter.inBounds(position: idx) && idx > lowerBound {
            if filter[idx] == .dot {
                return true
            }
            
            idx -= 1
        }
        return false
    }

    func isLogicalOperatorChar(_ c: UInt8) -> Bool {
        return c == kAndChar || c == kOrChar
    }

    func isRelationalOperatorChar(_ c: UInt8) -> Bool {
        return c == kLessThanChar || c == kGreaterThanChar || c == kEqualChar || c == kTildeChar || c == kNotChar
    }
}


/*
#pragma mark - SMJFilterCompiler

@implementation SMJFilterCompiler
{
	SMJCharacterIndex *_filter;
}

#pragma mark - SMJFilterCompiler - Compile
		
		SMJExpressionNode *logicalAND = [self readLogicalANDWithError:&lerror];

		if (!logicalAND)
		{
			[_filter setPosition:savepoint];
			break;
		}
		
		[ops addObject:logicalAND];
	}
	
	return (ops.count == 1 ? [ops firstObject] : [SMJLogicalExpressionNode logicalOrWithExpressionNodes:ops]);
}
			
- (nullable SMJExpressionNode *)readLogicalANDWithError:(NSError **)error
{
	NSMutableArray <SMJExpressionNode *> *ops = [NSMutableArray array];

	SMJExpressionNode *logicalAND = [self readLogicalANDOperandWithError:error];

	if (!logicalAND)
		return nil;
	
	[ops addObject:logicalAND];
	
	while (YES)
	{
		NSInteger	savepoint = _filter.position;
		NSError		*lerror = nil;

		if ([_filter hasSignificantString:SMJLogicalOperatorAND] == NO)
		{
			[_filter setPosition:savepoint];
			break;
		}
		
		SMJExpressionNode *logicalAND = [self readLogicalANDOperandWithError:&lerror];

		if (!logicalAND)
		{
			[_filter setPosition:savepoint];
			break;
		}
		
		[ops addObject:logicalAND];
	}
	
	return (ops.count == 1 ? [ops firstObject] : [SMJLogicalExpressionNode logicalAndWithExpressionNodes:ops]);
}

- (nullable SMJExpressionNode *)readLogicalANDOperandWithError:(NSError **)error
{
	NSInteger savepoint = [_filter skipBlanks].position;
	
	if ([[_filter skipBlanks] currentCharacterIsEqualTo:kNotChar])
	{
		if ([_filter readSignificantCharacter:kNotChar error:error] == NO)
			return nil;
		
		switch ([_filter skipBlanks].currentCharacter)
		{
			case kDocContextChar:
			case kEvalContextChar:
			{
				[_filter setPosition:savepoint];
				break;
			}
			default:
			{
				SMJExpressionNode *op = [self readLogicalANDOperandWithError:error];
				
				if (!op)
					return nil;
				
				return [SMJLogicalExpressionNode logicalNotWithExpressionNode:op];
			}
		}
	}
	
	if ([[_filter skipBlanks] currentCharacterIsEqualTo:kOpenParenthesisChar])
	{
		if ([_filter readSignificantCharacter:kOpenParenthesisChar error:error] == NO)
			return nil;
		
		SMJExpressionNode *op = [self readLogicalORWithError:error];
		
		if (!op)
			return nil;
		
		if ([_filter readSignificantCharacter:kCloseParenthesisChar error:error] == NO)
			return nil;
		
		return op;
	}
	
	return [self readExpressionWithError:error];
}

- (nullable SMJLogicalOperator *)readLogicalOperatorWithError:(NSError **)error
{
	NSInteger begin = [_filter skipBlanks].position;
	NSInteger end = begin + 1;
	
	if (![_filter isInBoundsIndex:end])
	{
		SMSetError(error, 1, @"Expected boolean literal");
		return nil;
	}
	
	NSString *logicalOperator = [_filter stringFromIndex:begin toIndex:end + 1];
	
	if (![logicalOperator isEqualToString:@"||"] && ![logicalOperator isEqualToString:@"&&"])
	{
		SMSetError(error, 2, @"Expected logical operator");
		return nil;
	}
	
	[_filter incrementPositionBy:logicalOperator.length];

	//logger.trace("LogicalOperator from {} to {} -> [{}]", begin, end, logicalOperator);
	
	return [SMJLogicalOperator logicalOperatorFromString:logicalOperator error:error];
}

- (nullable SMJRelationalOperator *)readRelationalOperatorWithError:(NSError **)error
{
	NSInteger begin = [_filter skipBlanks].position;
	
	if ([self isRelationalOperatorChar:_filter.currentCharacter])
	{
		while ([_filter inBounds] && [self isRelationalOperatorChar:_filter.currentCharacter])
		{
			[_filter incrementPositionBy:1];
		}
	}
	else
	{
		while ([_filter inBounds] && _filter.currentCharacter != kSpaceChar)
		{
			[_filter incrementPositionBy:1];
		}
	}
	
	NSString *operator = [_filter stringFromIndex:begin toIndex:_filter.position];
		
	//logger.trace("Operator from {} to {} -> [{}]", begin, filter.position()-1, operator);
	
	return [SMJRelationalOperator relationalOperatorFromString:operator error:error];
}

- (nullable SMJValueNode *)readValueNodeWithError:(NSError **)error
{
	switch ([_filter skipBlanks].currentCharacter)
	{
		case kDocContextChar:
			return [self readPathWithError:error];
					
		case kEvalContextChar:
			return [self readPathWithError:error];
			
		case kNotChar:
		{
			[_filter incrementPositionBy:1];
			
			switch ([_filter skipBlanks].currentCharacter)
			{
				case kDocContextChar:
					return [self readPathWithError:error];
					
				case kEvalContextChar:
					return [self readPathWithError:error];
					
				default:
				{
					SMSetError(error, 1, @"Unexpected character '%c'", kNotChar);
					return nil;
				}
			}
		}
			
		default:
			return [self readLiteralWithError:error];
	}
}

- (nullable SMJValueNode *)readLiteralWithError:(NSError **)error
{
	switch ([_filter skipBlanks].currentCharacter)
	{
		case kSingleQuoteChar:
			return [self readStringLiteral:kSingleQuoteChar withError:error];
			
		case kDoubleQuoteChar:
			return [self readStringLiteral:kDoubleQuoteChar withError:error];
			
		case kTrueChar:
			return [self readBooleanLiteralWithError:error];
			
		case kFalseChar:
			return [self readBooleanLiteralWithError:error];
			
		case kMinusChar:
			return [self readNumberLiteralWithError:error];
			
		case kNullChar:
			return [self readNullLiteralWithError:error];
			
		case kOpenObjectChar:
			return [self readJsonLiteralWithError:error];
			
		case kOpenArrayChar:
			return [self readJsonLiteralWithError:error];
			
		case kPatternChar:
			return [self readPatternWithError:error];
			
		default:
			return [self readNumberLiteralWithError:error];
	}
}

- (nullable SMJNullNode *)readNullLiteralWithError:(NSError **)error
{
	//NSInteger begin = _filter.position;
	
	if (_filter.currentCharacter == kNullChar && [_filter isInBoundsIndex:_filter.position + 3])
	{
		NSString *nullValue = [_filter stringFromIndex:_filter.position toIndex:_filter.position + 4];
		
		if ([nullValue isEqualToString:@"null"])
		{
			//logger.trace("NullLiteral from {} to {} -> [{}]", begin, filter.position()+3, nullValue);
			
			[_filter incrementPositionBy:nullValue.length];
			
			return [SMJValueNodes nullNode];
		}
	}
	
	SMSetError(error, 1, @"Expected <null> value");
	return nil;
}

- (nullable SMJJsonNode *)readJsonLiteralWithError:(NSError **)error
{
	NSInteger begin = _filter.position;
	
	unichar openChar = _filter.currentCharacter;
	
	if (openChar != kOpenArrayChar && openChar != kOpenObjectChar)
	{
		SMSetError(error, 1, @"internal error");
		return nil;
	}
	
	unichar closeChar = openChar == kOpenArrayChar ? kCloseArrayChar : kCloseObjectChar;
	
	NSInteger closingIndex = [_filter indexOfMatchingCloseCharacterFromIndex:_filter.position openCharacter:openChar closeCharacter:closeChar skipStrings:YES skipRegex:NO error:error];
							  
	
	if (closingIndex == NSNotFound)
	{
		SMSetError(error, 2, @"String not closed. Expected %c in %@", kSingleQuoteChar, _filter);
		return nil;
	}
	else
	{
		[_filter setPosition:closingIndex + 1];
	}
	
	NSString *json = [_filter stringFromIndex:begin toIndex:_filter.position];
	
	//logger.trace("JsonLiteral from {} to {} -> [{}]", begin, filter.position(), json);
	
	return [SMJValueNodes jsonNodeWithString:json];
}

- (nullable SMJPatternNode *)readPatternWithError:(NSError **)error
{
	NSInteger begin = _filter.position;
	NSInteger closingIndex = [_filter nextIndexOfUnescapedCharacter:kPatternChar];
	
	if (closingIndex == NSNotFound)
	{
		SMSetError(error, 1, @"Pattern not closed. Expected %c in %@", kPatternChar, _filter);
		return nil;
	}
	else
	{
		if ([_filter isInBoundsIndex:closingIndex + 1])
		{
			NSInteger equalSignIndex = [_filter nextIndexOfCharacter:'='];
			NSInteger endIndex = (equalSignIndex != NSNotFound ? equalSignIndex : [_filter nextIndexOfUnescapedCharacter:kCloseParenthesisChar]);
			NSString *flags = [_filter stringFromIndex:closingIndex + 1 toIndex:endIndex];
			
			closingIndex += flags.length;
		}
		
		[_filter setPosition:closingIndex + 1];
	}
	
	NSString *pattern = [_filter stringFromIndex:begin toIndex:_filter.position];
	
	//logger.trace("PatternNode from {} to {} -> [{}]", begin, filter.position(), pattern);
	
	return [SMJValueNodes patternNodeWithString:pattern];
}

- (nullable SMJStringNode *)readStringLiteral:(unichar)endChar withError:(NSError **)error
{
	NSInteger begin = _filter.position;
	
	NSInteger closingSingleQuoteIndex = [_filter nextIndexOfUnescapedCharacter:endChar];
	
	if (closingSingleQuoteIndex == NSNotFound)
	{
		SMSetError(error, 1, @"String literal does not have matching quotes. Expected %c in %@", endChar, _filter);
		return nil;
	}
	else
	{
		[_filter setPosition:closingSingleQuoteIndex + 1];
	}
	
	NSString *stringLiteral = [_filter stringFromIndex:begin toIndex:_filter.position];
	
	//logger.trace("StringLiteral from {} to {} -> [{}]", begin, filter.position(), stringLiteral);
	
	return [SMJValueNodes stringNodeWithString:stringLiteral escape:YES];
}


- (nullable SMJNumberNode *)readNumberLiteralWithError:(NSError **)error
{
	NSInteger begin = _filter.position;
	
	while ([_filter inBounds] && [_filter isNumberCharacterAtIndex:_filter.position])
	{
		[_filter incrementPositionBy:1];
	}
	
	NSString *numberLiteral = [_filter stringFromIndex:begin toIndex:_filter.position];
	
	//logger.trace("NumberLiteral from {} to {} -> [{}]", begin, filter.position(), numberLiteral);
	
	return [SMJValueNodes numberNodeWithString:numberLiteral];
}

- (nullable SMJBooleanNode *)readBooleanLiteralWithError:(NSError **)error
{
	NSInteger begin = _filter.position;
	NSInteger end = _filter.currentCharacter == kTrueChar ? _filter.position + 3 : _filter.position + 4;
	
	if (![_filter isInBoundsIndex:end])
	{
		SMSetError(error, 1, @"Expected boolean literal");
		return nil;
	}
	
	NSString *boolValue = [_filter stringFromIndex:begin toIndex:end + 1];
	
	if (![boolValue isEqualToString:@"true"] && ![boolValue isEqualToString:@"false"])
	{
		SMSetError(error, 2, @"Expected boolean literal");
		return nil;
	}
	
	[_filter incrementPositionBy:boolValue.length];
	
	//logger.trace("BooleanLiteral from {} to {} -> [{}]", begin, end, boolValue);
	
	return [SMJValueNodes booleanNodeWithString:boolValue];
}


- (nullable SMJPathNode *)readPathWithError:(NSError **)error
{
	unichar		previousSignificantChar = [_filter previousSignificantCharacter];
	NSInteger	begin = _filter.position;
	
	[_filter incrementPositionBy:1]; //skip $ and @
	
	while ([_filter inBounds])
	{
		if (_filter.currentCharacter == kOpenSquareBracketChar)
		{
			NSInteger closingSquareBracketIndex = [_filter indexOfMatchingCloseCharacterFromIndex:_filter.position openCharacter:kOpenSquareBracketChar closeCharacter:kCloseSquareBracketChar skipStrings:YES skipRegex:NO error:error];
			
			if (closingSquareBracketIndex == NSNotFound)
			{
				SMSetError(error, 1, @"Square brackets does not match in filter %@", _filter);
				return nil;
			}
			else
			{
				[_filter setPosition:closingSquareBracketIndex + 1];
			}
		}
		
		BOOL closingFunctionBracket = ((_filter.currentCharacter == kCloseParenthesisChar) && [self currentCharIsClosingFunctionBracket:begin]);
		BOOL closingLogicalBracket  = ((_filter.currentCharacter == kCloseParenthesisChar) && !closingFunctionBracket);
		
		if (![_filter inBounds] || [self isRelationalOperatorChar:_filter.currentCharacter] || (_filter.currentCharacter == kSpaceChar) || closingLogicalBracket)
		{
			break;
		}
		else
		{
			[_filter incrementPositionBy:1];
		}
	}
	
	BOOL		shouldExists = !(previousSignificantChar == kNotChar);
	NSString	*path = [_filter stringFromIndex:begin toIndex:_filter.position];
	
	return [SMJValueNodes pathNodeWithPathString:path existsCheck:NO shouldExists:shouldExists error:error];
}


- (BOOL)expressionIsTerminated
{
	unichar c = _filter.currentCharacter;
	
	if ((c == kCloseParenthesisChar) || [self isLogicalOperatorChar:c])
	{
		return YES;
	}
	
	c = [_filter nextSignificantCharacter];
	
	if ((c == kCloseParenthesisChar) || [self isLogicalOperatorChar:c])
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)currentCharIsClosingFunctionBracket:(NSInteger)lowerBound
{
	if (_filter.currentCharacter != kCloseParenthesisChar)
	{
		return NO;
	}
	
	NSInteger idx = [_filter indexOfPreviousSignificantCharacter];
	
	if ((idx == NSNotFound) || ([_filter characterAtIndex:idx] != kOpenParenthesisChar))
	{
		return NO;
	}
	
	idx--;
	
	while ([_filter isInBoundsIndex:idx] && idx > lowerBound)
	{
		if ([_filter characterAtIndex:idx] == kPeriodChar)
		{
			return YES;
		}
		
		idx--;
	}
	
	return NO;
}

- (BOOL)isLogicalOperatorChar:(unichar)c
{
	return c == kAndChar || c == kOrChar;
}

- (BOOL)isRelationalOperatorChar:(unichar)c
{
	return c == kLessThanChar || c == kGreaterThanChar || c == kEqualChar || c == kTildeChar || c == kNotChar;
}

@end




#pragma mark - SMJCompiledFilter

@implementation SMJCompiledFilter
{
	id <SMJPredicate> _predicate;
}


#pragma mark - SMJCompiledFilter - Instance

- (instancetype)initWithPredicate:(id <SMJPredicate>)predicate
{
	self = [super init];
	
	if (self)
	{
		_predicate = predicate;
	}
	
	return self;
}



#pragma mark - SMJCompiledFilter - SMFiler

- (SMJPredicateApply)applyWithContext:(id <SMJPredicateContext>)context error:(NSError **)error
{
	return [_predicate applyWithContext:context error:error];
}

- (NSString *)stringValue
{
	NSString *predicateString = [_predicate stringValue];
	
	if ([predicateString hasPrefix:@"("])
		return [NSString stringWithFormat:@"[?%@]", predicateString];
	else
		return [NSString stringWithFormat:@"[?(%@)]", predicateString];
}

@end


NS_ASSUME_NONNULL_END
*/
