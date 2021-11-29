import Foundation
import Hitch

fileprivate let docContextChar = UInt8.dollarSign
fileprivate let evalContextChar = UInt8.atMark
fileprivate let wildcardChar = UInt8.astericks
fileprivate let beginFilterChar = UInt8.questionMark
fileprivate let splitChar = UInt8.colon

final class PathCompiler {
    
    let ci: CharacterIndex
    
    init?(query: Hitch) {
        ci = CharacterIndex(query: query)
        
        ci.trim()
        guard isPathContext(ci.current()) else {
            error("Path must start with \(docContextChar) or \(evalContextChar)")
            return nil
        }
        
        if ci.last() == UInt8.dot {
            error("Path must not end with a '.' or '..'")
            return nil
        }
    }
    
    func compile() -> CompiledPath? {
        guard let root = readContextToken() else { return nil }
        
        return CompiledPath(root: root)
    }
    
    private func readContextToken() -> RootPathToken? {
        
        readWhitespace()
        
        guard isPathContext(ci.current()) else {
            error("Path must start with '$' or '@'")
            return nil
        }
        
        let pathToken = RootPathToken(root: ci.current())
        guard ci.positionAtEnd() == false else { return pathToken }
        
        ci.advance()
        
        guard ci.current() == .dot || ci.current() == .openBrace else {
            error("Illegal character at position \(ci.position) expected '.' or '[' and found \(ci.current())")
            return nil
        }
        
        guard readNextToken(appender: pathToken) else { return nil }
        
        return pathToken
    }
    
    private func readWhitespace() {
        while ci.inBounds() {
            guard isWhitespace(ci.current()) else { break }
            ci.advance()
        }
    }
    
    private func isWhitespace(_ c: UInt8) -> Bool {
        return c == UInt8.space || c == UInt8.tab || c == UInt8.lineFeed || c == UInt8.carriageReturn
    }
    
    private func isPathContext(_ c: UInt8) -> Bool {
        return c == docContextChar || c == evalContextChar
    }
    
    private func readNextToken(appender: PathToken) -> Bool {
        switch ci.current() {
        case .openBrace:
            var result = false
            fatalError("TO BE IMPLEMENTED")
            //result = result || readBracketPropertyToken(appender: appender)
            //result = result || readArrayToken(appender: appender)
            //result = result || readWildCardToken(appender: appender)
            //result = result || readFilterToken(appender: appender)
            guard result else {
                error("Could not parse token starting at position \(ci.position). Expected ?, ', 0-9, * ")
                return false
            }
            return true
        case .dot:
            var result = false
            result = result || readDotToken(appender: appender)
            guard result else {
                error("Could not parse token starting at position \(ci.position).")
                return false
            }
            return true
        case wildcardChar:
            var result = false
            fatalError("TO BE IMPLEMENTED")
            //result = result || readWildCardToken(appender: appender)
            guard result else {
                error("Could not parse token starting at position \(ci.position).")
                return false
            }
            return true
        default:
            var result = false
            result = result || readPropertyOrFunctionToken(appender: appender)
            guard result else {
                error("Could not parse token starting at position \(ci.position).")
                return false
            }
            return true
        }
    }
    
    private func readDotToken(appender: PathToken) -> Bool {
        if ci.current() == .dot && ci.next() == .dot {
            fatalError("TO BE IMPLEMENTED")
            //appender.append(tail: ScanPathToken())
            ci.advance(2)
        } else if ci.hasMoreCharacters() == false {
            error("Path must not end with a '.'")
            return false
        } else {
            ci.advance(1)
        }
        
        if ci.current() == .dot {
            error("Character '.' on position \(ci.position) is not valid.")
            return false
        }
        
        return readNextToken(appender: appender)
    }
    
    private func readPropertyOrFunctionToken(appender: PathToken) -> Bool {
        if ci.current() == .openBrace || ci.current() == wildcardChar || ci.current() == .dot || ci.current() == .space {
            return false
        }
        
        let startPosition = ci.position
        var readPosition = startPosition
        var endPosition = 0
        
        var isFunction = false
        
        while ci.inBounds(position: readPosition) {
            let c = ci[readPosition]
            if c == .space {
                error("Use bracket notion ['my prop'] if your property contains blank characters. position: \(readPosition)")
                return false
            } else if c == .dot || c == .openBrace {
                endPosition = readPosition
                break
            } else if c == .parenOpen {
                isFunction = true
                endPosition = readPosition
                break
            }
            readPosition += 1
        }
        
        if endPosition == 0 {
            endPosition = ci.count()
        }
        
        var functionParameters: [Parameter]? = nil
        
        if isFunction {
            if ci.inBounds(position: readPosition + 1) {
                // read the next token to determine if we have a simple no-args function call
                let c = ci[readPosition + 1]
                
                if c != .parenClose {
                    ci.position = endPosition + 1
                    
                    // parse the arguments of the function - arguments that are inner queries or JSON objet(s)
                    guard let functionName = ci.substring(startPosition, endPosition) else {
                        error("Failed to extract function name, position: \(readPosition)")
                        return false
                    }
                    
                    functionParameters = parseFunctionParameters(functionName)
                    if functionParameters == nil {
                        return false
                    }
                } else {
                    ci.position = readPosition + 1
                }
            } else {
                ci.position = readPosition
            }
        } else {
            ci.position = readPosition
        }
        
        if let property = ci.substring(startPosition, endPosition) {
            if let functionParameters = functionParameters {
                appender.append(tail: FunctionPathToken(name: property,
                                                        parameters: functionParameters))
            } else {
                guard let pathToken = PropertyPathToken(properties: [property],
                                                        wrap: UInt8.singleQuote) else { return false }
                
                appender.append(tail: pathToken)
            }
        }
        
        return ci.positionAtEnd() || readNextToken(appender: appender)
    }
    
    private func parseFunctionParameters(_ funcName: Hitch) -> [Parameter] {
        fatalError("TO BE IMPLEMENTED")
        return []
        
        /*
        NSNumber *type = nil; // SMJParamType
        
        // Parenthesis starts at 1 since we're marking the start of a function call, the close paren will denote the
        // last parameter boundary
        NSInteger    groupParen = 1, groupBracket = 0, groupBrace = 0, groupQuote = 0;
        BOOL         endOfStream = NO;
        unichar     priorChar = 0;
        
        NSMutableArray <SMJParameter *> *parameters = [[NSMutableArray alloc] init];
        NSMutableString *parameter = [[NSMutableString alloc] init];
        
        while ([_path inBounds] && !endOfStream)
        {
            unichar c = _path.currentCharacter;
            
            [_path incrementPositionBy:1];
            
            // we're at the start of the stream, and don't know what type of parameter we have
            if (type == nil)
            {
                if ([self isWhitespace:c])
                    continue;
                
                if (c == kOpenBraceChar || (c >= '0' && c <= '9') || kDoubleQuote == c)
                    type = @(SMJParamTypeJSON);
                else if ([self isPathContext:c])
                    type = @(SMJParamTypePath); // read until we reach a terminating comma and we've reset grouping to zero
            }
            
            switch (c)
            {
                case kDoubleQuote:
                {
                    if (priorChar != '\\' && groupQuote > 0)
                    {
                        if (groupQuote == 0)
                        {
                            SMSetError(error, 1, @"Unexpected quote '\"' at character position: %ld", (long)_path.position);
                            return nil;
                        }
                        
                        groupQuote--;
                    }
                    else
                    {
                        groupQuote++;
                    }
                    
                    break;
                }
                    
                case kOpenParenthesisChar:
                {
                    groupParen++;
                    break;
                }
                    
                case kOpenBraceChar:
                {
                    groupBrace++;
                    break;
                }
                    
                case kOpenSquareBracketChar:
                {
                    groupBracket++;
                    break;
                }
                    
                case kCloseBraceChar:
                {
                    if (groupBrace == 0)
                    {
                        SMSetError(error, 2, @"Unexpected close brace '}' at character position: %ld", (long)_path.position);
                        return nil;
                    }
                    groupBrace--;
                    break;
                }
                    
                case kCloseSquareBracketChar:
                {
                    if (groupBracket == 0)
                    {
                        SMSetError(error, 3, @"Unexpected close bracket ']' at character position: %ld", (long)_path.position);
                        return nil;
                    }
                    groupBracket--;
                    break;
                }
                    
                // In either the close paren case where we have zero paren groups left, capture the parameter, or where
                // we've encountered a kCommaChar do the same
                case kCloseParenthesisChar:
                {
                    groupParen--;
                    
                    if (groupParen != 0)
                        [parameter appendString:[NSString stringWithCharacters:&c length:1]];
                    
                    // No break.
                }
                    
                case kCommaChar:
                {
                    // In this state we've reach the end of a function parameter and we can pass along the parameter string
                    // to the parser
                    if ((groupQuote == 0 && groupBrace == 0 && groupBracket == 0 && ((groupParen == 0 && c == kCloseParenthesisChar) || groupParen == 1)))
                    {
                        endOfStream = (0 == groupParen);
                        
                        if (type != nil)
                        {
                            SMJParameter *param = nil;
                            
                            switch (type.intValue)
                            {
                                case SMJParamTypeJSON:
                                {
                                    // parse the json and set the value
                                    param = [[SMJParameter alloc] initWithJSON:parameter];
                                    break;
                                }
                                    
                                case SMJParamTypePath:
                                {
                                    id <SMJPath> path = [SMJPathCompiler compilePathString:parameter error:error];
                                    
                                    if (!path)
                                        return nil;
                                    
                                    param = [[SMJParameter alloc] initWithPath:path];
                                    
                                    break;
                                }
                            }
                            
                            if (param != nil)
                                [parameters addObject:param];
                            
                            [parameter deleteCharactersInRange:NSMakeRange(0, parameter.length)];
                            type = nil;
                        }
                    }
                    break;
                }
            }
            
            if (type != nil && !(c == kCommaChar && groupBrace == 0 && groupBracket == 0 && groupParen == 1))
                [parameter appendString:[NSString stringWithCharacters:&c length:1]];
            
            priorChar = c;
        }
        
        if (groupBrace != 0 || groupParen != 0 || groupBracket != 0)
        {
            SMSetError(error, 4, @"Arguments to function: '%@' are not closed properly.", funcName);
            return nil;
        }
        
        return parameters;
         */
    }
}

/*

- (nullable id <SMJPath>)compileWithError:(NSError **)error
{
	SMJRootPathToken *root = [self readContextTokenWithError:error];
	
	if (!root)
		return nil;
	
	return [[SMJCompiledPath alloc] initWithRootPathToken:root isRootPath:[root.pathFragment isEqualToString:@"$"]];
}

- (BOOL)isWhitespace:(unichar)c
{
	return (c == kSpaceChar || c == kTabChar || c == kLineFeedChar || c == kCarriageReturnChar);
}

- (BOOL)isPathContext:(unichar)c
{
	return (c == kDocContextChar || c == kEvalContextChar);
}

- (void)readWhitespace
{
	while ([_path inBounds])
	{
		unichar c = _path.currentCharacter;
		
		if (![self isWhitespace:c])
			break;
		
		[_path incrementPositionBy:1];
	}
}


//[$ | @]
- (SMJRootPathToken *)readContextTokenWithError:(NSError **)error
{
	
	[self readWhitespace];
	
	if (![self isPathContext:_path.currentCharacter])
	{
		SMSetError(error, 1, @"Path must start with '$' or '@'");
		return nil;
	}
	
	SMJRootPathToken *pathToken =  [[SMJRootPathToken alloc] initWithRootToken:_path.currentCharacter];
	
	if (_path.positionAtEnd)
		return pathToken;
	
	[_path incrementPositionBy:1];
	
	if (_path.currentCharacter != kPeriodChar && _path .currentCharacter != kOpenSquareBracketChar)
	{
		SMSetError(error, 2, @"Illegal character at position %ld expected '.' or '['", (long)_path.position);
		return nil;
	}
	
	id <SMJPathTokenAppender> appender = [pathToken pathTokenAppender];
	
	if ([self readNextToken:appender error:error] == NO)
		return nil;
	
	return pathToken;
}


//
//
//
- (BOOL)readNextToken:(id <SMJPathTokenAppender>)appender error:(NSError **)error
{
	unichar c = _path.currentCharacter;
	
	switch (c)
	{
		case kOpenSquareBracketChar:
		{
			BOOL result = NO;
			
			result = result || [self readBracketPropertyToken:appender error:error];
			result = result || [self readArrayToken:appender error:error];
			result = result || [self readWildCardToken:appender error:error];
			result = result || [self readFilterToken:appender error:error];
			
			if (result)
				return YES;
			
			SMSetError(error, 1, @"Could not parse token starting at position %ld . Expected ?, ', 0-9, * ", (long)_path .position);
			return NO;
		}
			
		case kPeriodChar:
		{
			BOOL result = NO;

			result = result || [self readDotToken:appender error:error];

			if (result)
				return YES;
			
			SMSetError(error, 2, @"Could not parse token starting at position %ld", (long)_path.position);
			return NO;
		}
			
		case kWildcardChar:
		{
			BOOL result = NO;
			
			result = result || [self readWildCardToken:appender error:error];
			
			if (result)
				return YES;
			
			SMSetError(error, 3, @"Could not parse token starting at position %ld", (long)_path.position);
			return NO;
		}
			
		default:
		{
			BOOL result = NO;
			
			result = result || [self readPropertyOrFunctionToken:appender error:error];
			
			if (result)
				return YES;
			
			SMSetError(error, 4, @"Could not parse token starting at position %ld", (long)_path.position);
			return NO;
		}
	}
}


//
// . and ..
//
- (BOOL)readDotToken:(id <SMJPathTokenAppender>)appender error:(NSError **)error
{
	if ([_path currentCharacterIsEqualTo:kPeriodChar] && [_path nextCharacterIsEqualTo:kPeriodChar])
	{
		[appender appendPathToken:[[SMJScanPathToken alloc] init]];
		[_path incrementPositionBy:2];
	}
	else if (_path.hasMoreCharacters == NO)
	{
		SMSetError(error, 1, @"Path must not end with a '.'");
		return NO;
	}
	else
	{
		[_path incrementPositionBy:1];
	}
	
	if ([_path currentCharacterIsEqualTo:kPeriodChar])
	{
		SMSetError(error, 1, @"Character '.' on position  %ld is not valid.", (long)_path.position);
		return NO;
	}
	
	return [self readNextToken:appender error:error];
}


//
// fooBar or fooBar()
//
- (BOOL)readPropertyOrFunctionToken:(id <SMJPathTokenAppender>)appender error:(NSError **)error
{
	if ([_path currentCharacterIsEqualTo:kOpenSquareBracketChar] || [_path currentCharacterIsEqualTo:kWildcardChar] || [_path currentCharacterIsEqualTo:kPeriodChar] || [_path currentCharacterIsEqualTo:kSpaceChar])
		return NO;
	
	NSInteger startPosition = _path.position;
	NSInteger readPosition = startPosition;
	NSInteger endPosition = 0;
	
	BOOL isFunction = NO;
	
	while ([_path isInBoundsIndex:readPosition])
	{
		unichar c = [_path characterAtIndex:readPosition];
		
		if (c == kSpaceChar)
		{
			SMSetError(error, 1, @"Use bracket notion ['my prop'] if your property contains blank characters. position: %ld", (long)readPosition);
			return NO;
		}
		else if (c == kPeriodChar || c == kOpenSquareBracketChar)
		{
			endPosition = readPosition;
			break;
		}
		else if (c == kOpenParenthesisChar)
		{
			isFunction = YES;
			endPosition = readPosition;
			break;
		}
		
		readPosition++;
	}
	
	if (endPosition == 0)
		endPosition = _path.length;
	
	NSArray <SMJParameter *> *functionParameters = nil;
	
	if (isFunction)
	{
		if ([_path isInBoundsIndex:readPosition + 1])
		{
			// read the next token to determine if we have a simple no-args function call
			unichar c = [_path characterAtIndex:readPosition + 1];
			
			if (c != kCloseParenthesisChar)
			{
				[_path setPosition:endPosition + 1];
				
				// parse the arguments of the function - arguments that are inner queries or JSON objet(s)
				NSString *functionName = [_path stringFromIndex:startPosition toIndex:endPosition];
				
				functionParameters = [self parseFunctionParameters:functionName error:error];
				
				if (!functionParameters)
					return NO;
			}
			else
			{
				[_path setPosition:readPosition + 1];
			}
		}
		else
		{
			[_path setPosition:readPosition];
		}
	}
	else
	{
		[_path setPosition:endPosition];
	}
	
	NSString *property = [_path stringFromIndex:startPosition toIndex:endPosition];
	
	if (isFunction)
	{
		[appender appendPathToken:[[SMJFunctionPathToken alloc] initWithPathFragment:property parameters:functionParameters]];
	}
	else
	{
		SMJPropertyPathToken *pathToken = [[SMJPropertyPathToken alloc] initWithProperties:@[property] delimiter:kSingleQuoteChar error:error];
		
		if (!pathToken)
			return NO;
		
		[appender appendPathToken:pathToken];
	}
	
	return _path.positionAtEnd || [self readNextToken:appender error:error];
}



- (NSArray <SMJParameter *>*)parseFunctionParameters:(NSString *)funcName error:(NSError **)error
{
	NSNumber *type = nil; // SMJParamType
	
	// Parenthesis starts at 1 since we're marking the start of a function call, the close paren will denote the
	// last parameter boundary
	NSInteger	groupParen = 1, groupBracket = 0, groupBrace = 0, groupQuote = 0;
	BOOL 		endOfStream = NO;
	unichar 	priorChar = 0;
	
	NSMutableArray <SMJParameter *> *parameters = [[NSMutableArray alloc] init];
	NSMutableString *parameter = [[NSMutableString alloc] init];
	
	while ([_path inBounds] && !endOfStream)
	{
		unichar c = _path.currentCharacter;
		
		[_path incrementPositionBy:1];
		
		// we're at the start of the stream, and don't know what type of parameter we have
		if (type == nil)
		{
			if ([self isWhitespace:c])
				continue;
			
			if (c == kOpenBraceChar || (c >= '0' && c <= '9') || kDoubleQuote == c)
				type = @(SMJParamTypeJSON);
			else if ([self isPathContext:c])
				type = @(SMJParamTypePath); // read until we reach a terminating comma and we've reset grouping to zero
		}
		
		switch (c)
		{
			case kDoubleQuote:
			{
				if (priorChar != '\\' && groupQuote > 0)
				{
					if (groupQuote == 0)
					{
						SMSetError(error, 1, @"Unexpected quote '\"' at character position: %ld", (long)_path.position);
						return nil;
					}
					
					groupQuote--;
				}
				else
				{
					groupQuote++;
				}
				
				break;
			}
				
			case kOpenParenthesisChar:
			{
				groupParen++;
				break;
			}
				
			case kOpenBraceChar:
			{
				groupBrace++;
				break;
			}
				
			case kOpenSquareBracketChar:
			{
				groupBracket++;
				break;
			}
				
			case kCloseBraceChar:
			{
				if (groupBrace == 0)
				{
					SMSetError(error, 2, @"Unexpected close brace '}' at character position: %ld", (long)_path.position);
					return nil;
				}
				groupBrace--;
				break;
			}
				
			case kCloseSquareBracketChar:
			{
				if (groupBracket == 0)
				{
					SMSetError(error, 3, @"Unexpected close bracket ']' at character position: %ld", (long)_path.position);
					return nil;
				}
				groupBracket--;
				break;
			}
				
			// In either the close paren case where we have zero paren groups left, capture the parameter, or where
			// we've encountered a kCommaChar do the same
			case kCloseParenthesisChar:
			{
				groupParen--;
				
				if (groupParen != 0)
					[parameter appendString:[NSString stringWithCharacters:&c length:1]];
				
				// No break.
			}
				
			case kCommaChar:
			{
				// In this state we've reach the end of a function parameter and we can pass along the parameter string
				// to the parser
				if ((groupQuote == 0 && groupBrace == 0 && groupBracket == 0 && ((groupParen == 0 && c == kCloseParenthesisChar) || groupParen == 1)))
				{
					endOfStream = (0 == groupParen);
					
					if (type != nil)
					{
						SMJParameter *param = nil;
						
						switch (type.intValue)
						{
							case SMJParamTypeJSON:
							{
								// parse the json and set the value
								param = [[SMJParameter alloc] initWithJSON:parameter];
								break;
							}
								
							case SMJParamTypePath:
							{
								id <SMJPath> path = [SMJPathCompiler compilePathString:parameter error:error];
								
								if (!path)
									return nil;
								
								param = [[SMJParameter alloc] initWithPath:path];
								
								break;
							}
						}
						
						if (param != nil)
							[parameters addObject:param];
						
						[parameter deleteCharactersInRange:NSMakeRange(0, parameter.length)];
						type = nil;
					}
				}
				break;
			}
		}
		
		if (type != nil && !(c == kCommaChar && groupBrace == 0 && groupBracket == 0 && groupParen == 1))
			[parameter appendString:[NSString stringWithCharacters:&c length:1]];
		
		priorChar = c;
	}
	
	if (groupBrace != 0 || groupParen != 0 || groupBracket != 0)
	{
		SMSetError(error, 4, @"Arguments to function: '%@' are not closed properly.", funcName);
		return nil;
	}
	
	return parameters;
}


//
// [?(...)]
//
- (BOOL)readFilterToken:(id <SMJPathTokenAppender>)appender error:(NSError **)error
{
	if (![_path currentCharacterIsEqualTo:kOpenSquareBracketChar] && ![_path nextSignificantCharacterIsEqualTo:kBeginFilterChar])
	{
		return NO;
	}
	
	NSInteger openStatementBracketIndex = _path.position;
	NSInteger questionMarkIndex = [_path indexOfNextSignificantCharacter:kBeginFilterChar];
	
	if (questionMarkIndex == NSNotFound)
	{
		return NO;
	}
	
	NSInteger openBracketIndex = [_path indexOfNextSignificantCharacter:kOpenParenthesisChar fromIndex:questionMarkIndex];
	
	if (openBracketIndex == NSNotFound)
	{
		return NO;
	}
	
	NSInteger closeBracketIndex = [_path indexOfClosingBracketFromIndex:openBracketIndex skipStrings:YES skipRegex:YES error:error];
	
	if (closeBracketIndex == NSNotFound)
	{
		return NO;
	}
	
	if (![_path nextSignificantCharacterIsEqualTo:kCloseSquareBracketChar fromIndex:closeBracketIndex])
	{
		return NO;
	}
	
	NSInteger closeStatementBracketIndex = [_path indexOfNextSignificantCharacter:kCloseSquareBracketChar fromIndex:closeBracketIndex];
	
	NSString *criteria = [_path stringFromIndex:openStatementBracketIndex toIndex:closeStatementBracketIndex + 1];
	
	id <SMJPredicate> predicate = [SMJFilterCompiler compileFilterString:criteria error:error];
	
	if (!predicate)
		return NO;
	
	[appender appendPathToken:[[SMJPredicatePathToken alloc] initWithPredicate:predicate]];
	
	[_path setPosition:closeStatementBracketIndex + 1];
	
	return _path.positionAtEnd || [self readNextToken:appender error:error];
}


//
// [*]
// *
//
- (BOOL)readWildCardToken:(id <SMJPathTokenAppender>)appender error:(NSError **)error
{
	BOOL inBracket = [_path currentCharacterIsEqualTo:kOpenSquareBracketChar];
	
	if (inBracket && ![_path nextSignificantCharacterIsEqualTo:kWildcardChar])
	{
		return false;
	}
	
	if (![_path currentCharacterIsEqualTo:kWildcardChar] && [_path isOutOfBoundsIndex:_path.position + 1])
	{
		return false;
	}
	
	if (inBracket)
	{
		NSInteger wildCardIndex = [_path indexOfNextSignificantCharacter:kWildcardChar];
		
		if (![_path nextSignificantCharacterIsEqualTo:kCloseSquareBracketChar fromIndex:wildCardIndex])
		{
			SMSetError(error, 4, @"Expected wildcard token to end with ']' on position %ld", (long)wildCardIndex + 1);
			return NO;
		}
		
		NSInteger bracketCloseIndex = [_path indexOfNextSignificantCharacter:kCloseSquareBracketChar fromIndex:wildCardIndex];
		
		[_path setPosition:bracketCloseIndex + 1];
	}
	else
	{
		[_path incrementPositionBy:1];
	}
	
	[appender appendPathToken:[[SMJWildcardPathToken alloc] init]];
	
	return _path.positionAtEnd || [self readNextToken:appender error:error];
}


//
// [1], [1,2, n], [1:], [1:2], [:2]
//
- (BOOL)readArrayToken:(id <SMJPathTokenAppender>)appender error:(NSError **)error
{
	if (![_path currentCharacterIsEqualTo:kOpenSquareBracketChar])
		return NO;
	
	unichar nextSignificantChar = [_path nextSignificantCharacter];
	
	if (!(nextSignificantChar >= '0' && nextSignificantChar <= '9') && nextSignificantChar != kMinusChar && nextSignificantChar != kSplitChar)
		return NO;
	
	NSInteger expressionBeginIndex = _path.position + 1;
	NSInteger expressionEndIndex = [_path nextIndexOfCharacter:kCloseSquareBracketChar fromIndex:expressionBeginIndex];
	
	if (expressionEndIndex == NSNotFound)
		return NO;
	
	NSString *expression = [[_path stringFromIndex:expressionBeginIndex toIndex:expressionEndIndex] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	if ([expression isEqualToString:@"*"])
		return NO;
	
	//check valid chars
	for (NSInteger i = 0; i < expression.length; i++)
	{
		unichar c = [expression characterAtIndex:i];
				
		if (!(c >= '0' && c <= '9') && c != kCommaChar && c != kMinusChar && c != kSplitChar && c != kSpaceChar)
			return NO;
	}
	
	BOOL isSliceOperation = ([expression rangeOfString:@":"].location != NSNotFound);
	
	if (isSliceOperation)
	{
		SMJArraySliceOperation *arraySliceOperation = [SMJArraySliceOperation arraySliceOperationByParsing:expression error:error];
		
		if (!arraySliceOperation)
			return NO;
		
		[appender appendPathToken:[[SMJArraySliceToken alloc] initWithSliceOperation:arraySliceOperation]];
	}
	else
	{
		SMJArrayIndexOperation *arrayIndexOperation = [SMJArrayIndexOperation arrayIndexOperation:expression error:error];
		
		if (!arrayIndexOperation)
			return NO;
		
		[appender appendPathToken:[[SMJArrayIndexToken alloc] initWithIndexOperation:arrayIndexOperation]];
	}
	
	[_path setPosition:expressionEndIndex + 1];
	
	return _path.positionAtEnd || [self readNextToken:appender error:error];
}


//
// ['foo']
//
- (BOOL)readBracketPropertyToken:(id <SMJPathTokenAppender>)appender error:(NSError **)error
{
	if (![_path currentCharacterIsEqualTo:kOpenSquareBracketChar])
	{
		return NO;
	}
	
	unichar potentialStringDelimiter = [_path nextSignificantCharacter];
	
	if (potentialStringDelimiter != kSingleQuoteChar && potentialStringDelimiter != kDoubleQuote)
	{
		return false;
	}
	
	NSMutableArray <NSString *> *properties = [NSMutableArray array];
	
	NSInteger startPosition = _path.position + 1;
	NSInteger readPosition = startPosition;
	NSInteger endPosition = 0;
	BOOL inProperty = NO;
	BOOL inEscape = NO;
	BOOL lastSignificantWasComma = NO;
	
	while ([_path isInBoundsIndex:readPosition])
	{
		unichar c = [_path characterAtIndex:readPosition];
		
		if (inEscape)
		{
			inEscape = NO;
		}
		else if (c == '\\')
		{
			inEscape = YES;
		}
		else if (c == kCloseSquareBracketChar && !inProperty)
		{
			if (lastSignificantWasComma)
			{
				SMSetError(error, 1, @"Found empty property at index %ld", (long)readPosition);
				return NO;
			}
			break;
		}
		else if (c == potentialStringDelimiter)
		{
			if (inProperty)
			{
				unichar nextSignificantChar = [_path nextSignificantCharacterFromIndex:readPosition];
				
				if (nextSignificantChar != kCloseSquareBracketChar && nextSignificantChar != kCommaChar)
				{
					SMSetError(error, 2, @"Property must be separated by comma or Property must be terminated close square bracket at index %ld", (long)readPosition);
					return NO;
				}
				
				endPosition = readPosition;
				
				NSString *prop = [_path stringFromIndex:startPosition toIndex:endPosition];
				
				[properties addObject:[SMJUtils stringByUnescapingString:prop]];
				
				inProperty = NO;
			}
			else
			{
				startPosition = readPosition + 1;
				inProperty = YES;
				lastSignificantWasComma = NO;
			}
		}
		else if (c == kCommaChar)
		{
			if (lastSignificantWasComma)
			{
				SMSetError(error, 2, @"Found empty property at index %ld", (long)readPosition);
				return NO;
			}
			
			lastSignificantWasComma = YES;
		}
		
		readPosition++;
	}
	
	if (inProperty)
	{
		SMSetError(error, 2, @"Property has not been closed - missing closing %c", (char)potentialStringDelimiter);
		return NO;
	}
	
	NSInteger endBracketIndex = [_path indexOfNextSignificantCharacter:kCloseSquareBracketChar fromIndex:endPosition] + 1;
	
	[_path setPosition:endBracketIndex];
	
	SMJPropertyPathToken *pathToken = [[SMJPropertyPathToken alloc] initWithProperties:properties delimiter:potentialStringDelimiter error:error];
	
	if (!pathToken)
		return NO;
	
	[appender appendPathToken:pathToken];
	
	return _path.positionAtEnd || [self readNextToken:appender error:error];
}

@end


NS_ASSUME_NONNULL_END
*/
