import Foundation

// swiftlint:disable identifier_name

internal extension CChar {

    @usableFromInline static let null: CChar = 0
    @usableFromInline static let startOfHeading: CChar = 1
    @usableFromInline static let startOfText: CChar = 2
    @usableFromInline static let endOfText: CChar = 3
    @usableFromInline static let endOfTransmission: CChar = 4
    @usableFromInline static let enquiry: CChar = 5
    @usableFromInline static let acknowledge: CChar = 6
    @usableFromInline static let bell: CChar = 7
    @usableFromInline static let backspace: CChar = 8
    @usableFromInline static let tab: CChar = 9
    @usableFromInline static let newLine: CChar = 10
    @usableFromInline static let lineFeed: CChar = 10
    @usableFromInline static let verticalTab: CChar = 11
    @usableFromInline static let formFeed: CChar = 12
    @usableFromInline static let carriageReturn: CChar = 13
    @usableFromInline static let shiftOut: CChar = 14
    @usableFromInline static let shiftIn: CChar = 15
    @usableFromInline static let dataLinkEscape: CChar = 16
    @usableFromInline static let deviceControl1: CChar = 17
    @usableFromInline static let deviceControl2: CChar = 18
    @usableFromInline static let deviceControl3: CChar = 19
    @usableFromInline static let deviceControl4: CChar = 20

    @usableFromInline static let negativeAcknowledge: CChar = 21
    @usableFromInline static let synchronousIdle: CChar = 22
    @usableFromInline static let endOfBlock: CChar = 23
    @usableFromInline static let cancel: CChar = 24
    @usableFromInline static let endOfMedium: CChar = 25
    @usableFromInline static let substitute: CChar = 26
    @usableFromInline static let escape: CChar = 27
    @usableFromInline static let fileSeparator: CChar = 28
    @usableFromInline static let groupSeparator: CChar = 29
    @usableFromInline static let recordSeparator: CChar = 30
    @usableFromInline static let unitSeparator: CChar = 31

    @usableFromInline static let space: CChar = 32
    @usableFromInline static let bang: CChar = 33
    @usableFromInline static let doubleQuote: CChar = 34
    @usableFromInline static let hashTag: CChar = 35
    @usableFromInline static let dollarSign: CChar = 36
    @usableFromInline static let percentSign: CChar = 37
    @usableFromInline static let ampersand: CChar = 38
    @usableFromInline static let singleQuote: CChar = 39
    @usableFromInline static let parenOpen: CChar = 40
    @usableFromInline static let parenClose: CChar = 41
    @usableFromInline static let astericks: CChar = 42
    @usableFromInline static let plus: CChar = 43
    @usableFromInline static let comma: CChar = 44
    @usableFromInline static let minus: CChar = 45
    @usableFromInline static let dot: CChar = 46
    @usableFromInline static let forwardSlash: CChar = 47

    @usableFromInline static let zero: CChar = 48
    @usableFromInline static let one: CChar = 49
    @usableFromInline static let two: CChar = 50
    @usableFromInline static let three: CChar = 51
    @usableFromInline static let four: CChar = 52
    @usableFromInline static let five: CChar = 53
    @usableFromInline static let six: CChar = 54
    @usableFromInline static let seven: CChar = 55
    @usableFromInline static let eight: CChar = 56
    @usableFromInline static let nine: CChar = 57

    @usableFromInline static let colon: CChar = 58
    @usableFromInline static let semiColon: CChar = 59
    @usableFromInline static let lessThan: CChar = 60
    @usableFromInline static let equal: CChar = 61
    @usableFromInline static let greaterThan: CChar = 62
    @usableFromInline static let questionMark: CChar = 63
    @usableFromInline static let atMark: CChar = 64

    @usableFromInline static let A: CChar = 65
    @usableFromInline static let B: CChar = 66
    @usableFromInline static let C: CChar = 67
    @usableFromInline static let D: CChar = 68
    @usableFromInline static let E: CChar = 69
    @usableFromInline static let F: CChar = 70
    @usableFromInline static let G: CChar = 71
    @usableFromInline static let H: CChar = 72
    @usableFromInline static let I: CChar = 73
    @usableFromInline static let J: CChar = 74
    @usableFromInline static let K: CChar = 75
    @usableFromInline static let L: CChar = 76
    @usableFromInline static let M: CChar = 77
    @usableFromInline static let N: CChar = 78
    @usableFromInline static let O: CChar = 79
    @usableFromInline static let P: CChar = 80
    @usableFromInline static let Q: CChar = 81
    @usableFromInline static let R: CChar = 82
    @usableFromInline static let S: CChar = 83
    @usableFromInline static let T: CChar = 84
    @usableFromInline static let U: CChar = 85
    @usableFromInline static let V: CChar = 86
    @usableFromInline static let W: CChar = 87
    @usableFromInline static let X: CChar = 88
    @usableFromInline static let Y: CChar = 89
    @usableFromInline static let Z: CChar = 90

    @usableFromInline static let openBrace: CChar = 91
    @usableFromInline static let backSlash: CChar = 92
    @usableFromInline static let closeBrace: CChar = 93
    @usableFromInline static let carrat: CChar = 94
    @usableFromInline static let underscore: CChar = 95
    @usableFromInline static let backtick: CChar = 96

    @usableFromInline static let a: CChar = 97
    @usableFromInline static let b: CChar = 98
    @usableFromInline static let c: CChar = 99
    @usableFromInline static let d: CChar = 100
    @usableFromInline static let e: CChar = 101
    @usableFromInline static let f: CChar = 102
    @usableFromInline static let g: CChar = 103
    @usableFromInline static let h: CChar = 104
    @usableFromInline static let i: CChar = 105
    @usableFromInline static let j: CChar = 106
    @usableFromInline static let k: CChar = 107
    @usableFromInline static let l: CChar = 108
    @usableFromInline static let m: CChar = 109
    @usableFromInline static let n: CChar = 110
    @usableFromInline static let o: CChar = 111
    @usableFromInline static let p: CChar = 112
    @usableFromInline static let q: CChar = 113
    @usableFromInline static let r: CChar = 114
    @usableFromInline static let s: CChar = 115
    @usableFromInline static let t: CChar = 116
    @usableFromInline static let u: CChar = 117
    @usableFromInline static let v: CChar = 118
    @usableFromInline static let w: CChar = 119
    @usableFromInline static let x: CChar = 120
    @usableFromInline static let y: CChar = 121
    @usableFromInline static let z: CChar = 122

    @usableFromInline static let openBracket: CChar = 123
    @usableFromInline static let pipe: CChar = 124
    @usableFromInline static let closeBracket: CChar = 125
    @usableFromInline static let tilde: CChar = 126
    @usableFromInline static let del: CChar = 127
}
