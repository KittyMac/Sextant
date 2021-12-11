import Foundation
import Hitch

private let regexChar = UInt8.forwardSlash

class CharacterIndex: CustomStringConvertible {
    @usableFromInline
    internal let charSequence: Hitch

    var position: Int
    var endPosition: Int

    init(query: Hitch) {
        charSequence = query
        position = 0
        endPosition = charSequence.count - 1
    }

    var description: String {
        return charSequence.description
    }

    @inlinable @inline(__always)
    func substring(_ from: Int, _ to: Int) -> Hitch? {
        return charSequence.substring(from, to)
    }

    @inlinable @inline(__always)
    func count() -> Int {
        return charSequence.count
    }

    @inlinable @inline(__always)
    func current() -> UInt8 {
        return charSequence[position]
    }

    @inlinable @inline(__always)
    func next() -> UInt8 {
        guard position < endPosition else { return 0 }
        return charSequence[position + 1]
    }

    @inlinable @inline(__always)
    func advance(_ count: Int = 1) {
        position += count
    }

    @inlinable @inline(__always)
    func removeFromEnd(_ count: Int = 1) {
        endPosition = endPosition - count
    }

    @inlinable @inline(__always)
    func positionAtEnd() -> Bool {
        return position >= endPosition
    }

    @inlinable @inline(__always)
    subscript (index: Int) -> UInt8 {
        get { return charSequence[index] }
        set(newValue) { charSequence[index] = newValue }
    }

    @inlinable @inline(__always)
    func last() -> UInt8 {
        return charSequence[endPosition]
    }

    @inlinable @inline(__always)
    func first() -> UInt8 {
        return charSequence[position]
    }

    @inlinable @inline(__always)
    func inBounds(position: Int) -> Bool {
        return position >= 0 && position <= endPosition
    }

    @inlinable @inline(__always)
    func inBounds() -> Bool {
        return position >= 0 && position <= endPosition
    }

    @inlinable @inline(__always)
    func hasMoreCharacters() -> Bool {
        return position < endPosition
    }

    @discardableResult
    func trim() -> Self {
        skipBlanks()
        skipBlanksAtEnd()
        return self
    }

    @discardableResult
    func skipBlanks() -> Self {
        while inBounds() && position < endPosition && charSequence[position] == UInt8.space {
            advance()
        }
        return self
    }

    @discardableResult
    func skipBlanksAtEnd() -> Self {
        while inBounds() && position < endPosition && charSequence[endPosition] == UInt8.space {
            endPosition -= 1
        }
        return self
    }

    func compare(hitch: Hitch) -> Bool {
        let end = hitch.count
        var idx = 0
        while inBounds(position: idx + position) && idx < end {
            if hitch[idx] != charSequence[idx + position] {
                return false
            }
            idx += 1
        }
        return idx == end
    }

    func compareAndAdvance(hitch: Hitch) -> Bool {
        if compare(hitch: hitch) {
            advance(hitch.count)
            return true
        }
        return false
    }

    func nextIndexOfUnescapedCharacter(character: UInt8) -> Int {
        return nextIndexOfUnescapedCharacter(character: character,
                                             from: position)
    }

    func isNumberCharacter(index: Int) -> Bool {
        let character = charSequence[index]
        return (character >= .zero && character <= .nine) || character == .minus  || character == .dot
    }

    func nextIndexOfUnescapedCharacter(character: UInt8,
                                       from: Int) -> Int {
        var readPosition = from + 1
        var inEscape = false
        while inBounds(position: readPosition) {
            if inEscape {
                inEscape = false
            } else if charSequence[readPosition] == .backSlash {
                inEscape = true
            } else if charSequence[readPosition] == character {
                return readPosition
            }
            readPosition += 1
        }
        return -1
    }

    func indexOfPreviousSignificantCharacter() -> Int {
        return indexOfPreviousSignificantCharacter(index: position)
    }

    func indexOfPreviousSignificantCharacter(index startPosition: Int) -> Int {
        var readPosition = startPosition - 1

        while inBounds() && charSequence[readPosition] == .space {
            readPosition -= 1
        }

        guard inBounds() else {
            return -1
        }
        return readPosition
    }

    func previousSignificantCharacter(index startPosition: Int) -> UInt8 {
        let previousSignificantCharIndex = indexOfPreviousSignificantCharacter(index: startPosition)
        guard previousSignificantCharIndex >= 0 else { return .space }
        return charSequence[previousSignificantCharIndex]
    }

    func previousSignificantCharacter() -> UInt8 {
        return previousSignificantCharacter(index: position)
    }

    func nextSignificantCharacter() -> UInt8 {
        return nextSignificantCharacter(index: position)
    }

    func nextSignificantCharacter(index startPosition: Int) -> UInt8 {
        var readPosition = startPosition + 1

        while inBounds(position: readPosition) && charSequence[readPosition] == .space {
            readPosition += 1
        }

        if inBounds(position: readPosition) {
            return charSequence[readPosition]
        }
        return .space
    }

    func readSignificantCharacter(character: UInt8) -> Bool {
        let c = skipBlanks().current()
        if c != character {
            error("Expected character '\(character)' but found '\(c)'")
            return false
        }
        advance(1)
        return true
    }

    func hasSignificantString(string: Hitch) -> Bool {
        skipBlanks()

        guard compare(hitch: string) else { return false }

        advance(string.count)
        return true
    }

    func nextIndexOfCharacter(character: UInt8) -> Int {
        return nextIndexOfCharacter(character: character,
                                    from: position + 1)
    }

    func nextIndexOfCharacter(character: UInt8,
                              from: Int) -> Int {
        var readPosition = from
        while inBounds(position: readPosition) {
            if charSequence[readPosition] == character {
                return readPosition
            }
            readPosition += 1
        }
        return -1
    }

    func indexOfNextSignificantCharacter(character: UInt8) -> Int {
        return indexOfNextSignificantCharacter(character: character,
                                               from: position)
    }

    func indexOfNextSignificantCharacter(character: UInt8,
                                         from: Int) -> Int {
        var readPosition = from + 1

        while inBounds() && charSequence[readPosition] == .space {
            readPosition += 1
        }

        if charSequence[readPosition] == character {
            return readPosition
        }
        return -1
    }

    func indexOfMatchingCloseCharacter(index startPosition: Int,
                                       openChar: UInt8,
                                       closeChar: UInt8,
                                       skipStrings: Bool,
                                       skipRegex: Bool) -> Int {
        guard charSequence[startPosition] == openChar else {
            error("Expected \(openChar) but found \(charSequence[startPosition])")
            return -1
        }

        var opened = 1
        var readPosition = startPosition + 1

        while inBounds(position: readPosition) {
            if skipStrings {
                let quoteChar = charSequence[readPosition]
                if quoteChar == .singleQuote || quoteChar == .doubleQuote {
                    readPosition = nextIndexOfUnescapedCharacter(character: quoteChar,
                                                                 from: readPosition)

                    guard readPosition >= 0 else {
                        error("Could not find matching close quote for \(quoteChar) when parsing : \(charSequence)")
                        return -1
                    }

                    readPosition += 1
                }
            }

            if skipRegex {
                if charSequence[readPosition] == regexChar {
                    readPosition = nextIndexOfUnescapedCharacter(character: regexChar,
                                                                 from: readPosition)

                    guard readPosition >= 0 else {
                        error("Could not find matching close for \(regexChar) when parsing regex in : \(charSequence)")
                        return -1
                    }

                    readPosition += 1
                }
            }

            if charSequence[readPosition] == openChar {
                opened += 1
            }

            if charSequence[readPosition] == closeChar {
                opened -= 1
                if opened == 0 {
                    return readPosition
                }
            }

            readPosition += 1
        }

        return -1
    }

    func indexOfClosingBracket(index startPosition: Int,
                               skipStrings: Bool,
                               skipRegex: Bool) -> Int {
        return indexOfMatchingCloseCharacter(index: startPosition,
                                             openChar: .parenOpen,
                                             closeChar: .parenClose,
                                             skipStrings: skipStrings,
                                             skipRegex: skipRegex)
    }
}

/*

#import "SMJCharacterIndex.h"


NS_ASSUME_NONNULL_BEGIN



#pragma mark Defines

#define kOpenParenthesisChar 	'('
#define kCloseParenthesisChar 	')'
#define kCloseSquareBracketChar ']'
#define kSpaceChar 				' '
#define kEscapeChar				'\\'
#define kSingleQuoteChar 		'\''
#define kDoubleQuoteChar 		'"'
#define kMinusChar 				'-'
#define kPeriodChar 			'.'
#define kRegexChar 				'/'



#pragma mark Macros

#define SMSetError(Error, Code, Message, ...) \
	do { \
		if (Error) {\
			NSString *___message = [NSString stringWithFormat:(Message), ## __VA_ARGS__];\
			*(Error) = [NSError errorWithDomain:@"SMJCharacterIndexErrorDomain" code:(Code) userInfo:@{ NSLocalizedDescriptionKey : ___message }]; \
		} \
	} while (0) \



#pragma mark SMJCharacterIndex

@implementation SMJCharacterIndex
{
	NSString *_charSequence;
}

- (instancetype)initWithString:(NSString *)string
{
	self = [super init];
	
	if (self)
	{
		_charSequence = [string copy];
		_position = 0;
		_endPosition = string.length - 1;
	}
	
	return self;
}

- (NSInteger)length
{
	return _endPosition + 1;
}

- (BOOL)positionAtEnd
{
	return _position >= _endPosition;
}

- (BOOL)hasMoreCharacters
{
	return [self isInBoundsIndex:_position + 1];
}

- (BOOL)isInBoundsIndex:(NSInteger)index
{
	return (index >= 0) && (index <= _endPosition);
}

- (BOOL)inBounds
{
	return [self isInBoundsIndex:_position];
}

- (BOOL)isOutOfBoundsIndex:(NSInteger)index
{
	return ![self isInBoundsIndex:index];
}

- (unichar)characterAtIndex:(NSInteger)index
{
	return [_charSequence characterAtIndex:index];
}

- (unichar)characterAtIndex:(NSInteger)position defaultCharacter:(unichar)defaultChar
{
	if (![self isInBoundsIndex:position])
		return defaultChar;
	else
		return [self characterAtIndex:position];
}

- (unichar)currentCharacter
{
	return [_charSequence characterAtIndex:_position];
}

- (BOOL)currentCharacterIsEqualTo:(unichar)character
{
	return ([_charSequence characterAtIndex:_position] == character);
}

- (BOOL)lastCharacterIsEqualTo:(unichar)character
{
	return ([_charSequence characterAtIndex:_endPosition] == character);
}

- (BOOL)nextCharacterIsEqualTo:(unichar)character
{
	return [self isInBoundsIndex:_position + 1] && ([_charSequence characterAtIndex:_position + 1] == character);
}

- (NSInteger)incrementPositionBy:(NSInteger)charCount
{
	_position = _position + charCount;
	
	return _position;
}

- (NSInteger)decrementEndPositionBy:(NSInteger)charCount
{
	_endPosition = _endPosition - charCount;
	
	return _endPosition;
}

- (NSInteger)indexOfClosingSquareBracketFromIndex:(NSInteger)startPosition
{
	NSInteger readPosition = startPosition;
	
	while ([self isInBoundsIndex:readPosition])
	{
		if ([self characterAtIndex:readPosition] == kCloseSquareBracketChar)
		{
			return readPosition;
		}
		
		readPosition++;
	}
	
	return NSNotFound;
}

- (NSInteger)indexOfMatchingCloseCharacterFromIndex:(NSInteger)startPosition openCharacter:(unichar)openChar closeCharacter:(unichar)closeChar skipStrings:(BOOL)skipStrings skipRegex:(BOOL)skipRegex error:(NSError **)error
{
	if ([self characterAtIndex:startPosition] != openChar)
	{
		SMSetError(error, 1, @"Expected %c but found %c", (char)openChar, (char)[self characterAtIndex:startPosition]);
		return NSNotFound;
	}
	
	NSInteger opened = 1;
	NSInteger readPosition = startPosition + 1;
	
	while ([self isInBoundsIndex:readPosition])
	{
		if (skipStrings)
		{
			unichar quoteChar = [self characterAtIndex:readPosition];
			
			if (quoteChar == kSingleQuoteChar || quoteChar == kDoubleQuoteChar)
			{
				readPosition = [self nextIndexOfUnescapedCharacter:quoteChar fromIndex:readPosition];
				
				if (readPosition == NSNotFound)
				{
					SMSetError(error, 1, @"Could not find matching close quote for %c when parsing : %@", (char)quoteChar, _charSequence);
					return NSNotFound;
				}
				
				readPosition++;
			}
		}
		
		if (skipRegex)
		{
			if ([self characterAtIndex:readPosition] == kRegexChar)
			{
				readPosition = [self nextIndexOfUnescapedCharacter:kRegexChar fromIndex:readPosition];
				
				if (readPosition == NSNotFound)
				{
					SMSetError(error, 2, @"Could not find matching close for %c when parsing regex in : %@", (char)kRegexChar, _charSequence);
					return NSNotFound;
				}
				
				readPosition++;
			}
		}
		
		if ([self characterAtIndex:readPosition] == openChar)
		{
			opened++;
		}
		
		if ([self characterAtIndex:readPosition] == closeChar)
		{
			opened--;
			
			if (opened == 0)
			{
				return readPosition;
			}
		}
		readPosition++;
	}
			 
	return NSNotFound;
}

- (NSInteger)indexOfClosingBracketFromIndex:(NSInteger)startPosition skipStrings:(BOOL)skipStrings skipRegex:(BOOL)skipRegex error:(NSError **)error
{
	return [self indexOfMatchingCloseCharacterFromIndex:startPosition openCharacter:kOpenParenthesisChar closeCharacter:kCloseParenthesisChar skipStrings:skipStrings skipRegex:skipRegex error:error];
}


- (NSInteger)indexOfNextSignificantCharacter:(unichar)character
{
	return [self indexOfNextSignificantCharacter:character fromIndex:_position];
}

- (NSInteger)indexOfNextSignificantCharacter:(unichar)character fromIndex:(NSInteger)startPosition
{
	NSInteger readPosition = startPosition + 1;
	
	while (![self isOutOfBoundsIndex:readPosition] && [self characterAtIndex:readPosition] == kSpaceChar)
		readPosition++;
	
	if ([self characterAtIndex:readPosition] == character)
		return readPosition;
	else
		return NSNotFound;
}

- (NSInteger)nextIndexOfCharacter:(unichar)character
{
	return [self nextIndexOfCharacter:character fromIndex:_position + 1];
}

- (NSInteger)nextIndexOfCharacter:(unichar)character fromIndex:(NSInteger)startPosition
{
	NSInteger readPosition = startPosition;
	
	while (![self isOutOfBoundsIndex:readPosition])
	{
		if ([self characterAtIndex:readPosition] == character)
		{
			return readPosition;
		}
		
		readPosition++;
	}
	
	return NSNotFound;
}

- (NSInteger)nextIndexOfUnescapedCharacter:(unichar)character
{
	return [self nextIndexOfUnescapedCharacter:character fromIndex:_position];
}

- (NSInteger)nextIndexOfUnescapedCharacter:(unichar)character fromIndex:(NSInteger)startPosition
{
	NSInteger readPosition = startPosition + 1;
	BOOL inEscape = NO;
	
	while ([self isOutOfBoundsIndex:readPosition] == NO)
	{
		if (inEscape)
		{
			inEscape = NO;
		}
		else if ([self characterAtIndex:readPosition] == '\\')
		{
			inEscape = TRUE;
		}
		else if ([self characterAtIndex:readPosition] == character)
		{
			return readPosition;
		}
		
		readPosition ++;
	}
	
	return NSNotFound;
}

- (BOOL)nextSignificantCharacterIsEqualTo:(unichar)character
{
	return [self nextSignificantCharacterIsEqualTo:character fromIndex:_position];
}

- (BOOL)nextSignificantCharacterIsEqualTo:(unichar)character fromIndex:(NSInteger)startPosition
{
	NSInteger readPosition = startPosition + 1;
	
	while (![self isOutOfBoundsIndex:readPosition] && [self characterAtIndex:readPosition] == kSpaceChar)
	{
		readPosition++;
	}
	
	return ([self isOutOfBoundsIndex:readPosition] == NO) && [self characterAtIndex:readPosition] == character;
}

- (unichar)nextSignificantCharacter
{
	return [self nextSignificantCharacterFromIndex:_position];
}

- (unichar)nextSignificantCharacterFromIndex:(NSInteger)startPosition
{
	NSInteger readPosition = startPosition + 1;
	
	while (![self isOutOfBoundsIndex:readPosition] && [self characterAtIndex:readPosition] == kSpaceChar)
	{
		readPosition++;
	}
	
	if (![self isOutOfBoundsIndex:readPosition])
	{
		return [self characterAtIndex:readPosition];
	}
	else
	{
		return ' ';
	}
}

- (BOOL)readSignificantCharacter:(unichar)character error:(NSError **)error
{
	if ([self skipBlanks].currentCharacter != character)
	{
		SMSetError(error, 1, @"Expected character '%c' but found '%c'", (char)character, (char)([self skipBlanks].currentCharacter));
		return NO;
	}
	
	[self incrementPositionBy:1];
	
	return YES;
}

- (BOOL)hasSignificantString:(NSString *)string
{
	[self skipBlanks];
	
	if (![self isInBoundsIndex:_position + string.length - 1])
		return NO;
	
	if (![[self stringFromIndex:_position toIndex:_position + string.length] isEqualToString:string])
		return NO;
	
	[self incrementPositionBy:string.length];
	
	return YES;
}

- (NSInteger)indexOfPreviousSignificantCharacter
{
	return [self indexOfPreviousSignificantCharacterFromIndex:_position];
}

- (NSInteger)indexOfPreviousSignificantCharacterFromIndex:(NSInteger)startPosition
{
	NSInteger readPosition = startPosition - 1;
	
	while (![self isOutOfBoundsIndex:readPosition] && [self characterAtIndex:readPosition] == kSpaceChar)
	{
		readPosition--;
	}
	
	if (![self isOutOfBoundsIndex:readPosition])
	{
		return readPosition;
	}
	else
	{
		return NSNotFound;
	}
}

- (unichar)previousSignificantCharacterFromIndex:(NSInteger)startPosition
{
	NSInteger previousSignificantCharIndex = [self indexOfPreviousSignificantCharacterFromIndex:startPosition];
	
	if (previousSignificantCharIndex == NSNotFound)
		return ' ';
	else
		return [self characterAtIndex:previousSignificantCharIndex];
}

- (unichar)previousSignificantCharacter
{
	return [self previousSignificantCharacterFromIndex:_position];
}

- (NSString *)stringFromIndex:(NSInteger)start toIndex:(NSInteger)end
{
	return [_charSequence substringWithRange:NSMakeRange(start, end - start)];
}

- (NSString *)stringValue
{
	return _charSequence;
}

- (BOOL)isNumberCharacterAtIndex:(NSInteger)readPosition
{
	unichar character = [self characterAtIndex:readPosition];
	
	return (character >= '0' && character <= '9') || character == kMinusChar  || character == kPeriodChar;
}

- (SMJCharacterIndex *)skipBlanks
{
	while ([self inBounds] && _position < _endPosition  && self.currentCharacter == kSpaceChar)
	{
		[self incrementPositionBy:1];
	}
	
	return self;
}

- (SMJCharacterIndex *)skipBlanksAtEnd
{
	while ([self inBounds] && _position < _endPosition && [self lastCharacterIsEqualTo:kSpaceChar])
	{
		[self decrementEndPositionBy:1];
	}
	
	return self;
}

- (SMJCharacterIndex *)trim
{
	[self skipBlanks];
	[self skipBlanksAtEnd];
	
	return self;
}

@end


NS_ASSUME_NONNULL_END
*/
