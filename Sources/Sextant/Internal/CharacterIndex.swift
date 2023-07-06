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

    @inlinable
    func substring(_ from: Int, _ to: Int) -> Hitch? {
        return charSequence.substring(from, to)
    }

    @inlinable
    func count() -> Int {
        return charSequence.count
    }

    @inlinable
    func current() -> UInt8 {
        return charSequence[position]
    }

    @inlinable
    func next() -> UInt8 {
        guard position < endPosition else { return 0 }
        return charSequence[position + 1]
    }

    @inlinable
    func advance(_ count: Int = 1) {
        position += count
    }

    @inlinable
    func removeFromEnd(_ count: Int = 1) {
        endPosition = endPosition - count
    }

    @inlinable
    func positionAtEnd() -> Bool {
        return position >= endPosition
    }

    @inlinable
    subscript (index: Int) -> UInt8 {
        get { return charSequence[index] }
        set(newValue) { charSequence[index] = newValue }
    }

    @inlinable
    func last() -> UInt8 {
        return charSequence[endPosition]
    }

    @inlinable
    func first() -> UInt8 {
        return charSequence[position]
    }

    @inlinable
    func inBounds(position: Int) -> Bool {
        return position >= 0 && position <= endPosition
    }

    @inlinable
    func inBounds() -> Bool {
        return position >= 0 && position <= endPosition
    }

    @inlinable
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
