import Foundation

// swiftlint:disable identifier_name

internal extension UInt8 {

    @usableFromInline static let null: UInt8 = 0
    @usableFromInline static let startOfHeading: UInt8 = 1
    @usableFromInline static let startOfText: UInt8 = 2
    @usableFromInline static let endOfText: UInt8 = 3
    @usableFromInline static let endOfTransmission: UInt8 = 4
    @usableFromInline static let enquiry: UInt8 = 5
    @usableFromInline static let acknowledge: UInt8 = 6
    @usableFromInline static let bell: UInt8 = 7
    @usableFromInline static let backspace: UInt8 = 8
    @usableFromInline static let tab: UInt8 = 9
    @usableFromInline static let newLine: UInt8 = 10
    @usableFromInline static let lineFeed: UInt8 = 10
    @usableFromInline static let verticalTab: UInt8 = 11
    @usableFromInline static let formFeed: UInt8 = 12
    @usableFromInline static let carriageReturn: UInt8 = 13
    @usableFromInline static let shiftOut: UInt8 = 14
    @usableFromInline static let shiftIn: UInt8 = 15
    @usableFromInline static let dataLinkEscape: UInt8 = 16
    @usableFromInline static let deviceControl1: UInt8 = 17
    @usableFromInline static let deviceControl2: UInt8 = 18
    @usableFromInline static let deviceControl3: UInt8 = 19
    @usableFromInline static let deviceControl4: UInt8 = 20

    @usableFromInline static let negativeAcknowledge: UInt8 = 21
    @usableFromInline static let synchronousIdle: UInt8 = 22
    @usableFromInline static let endOfBlock: UInt8 = 23
    @usableFromInline static let cancel: UInt8 = 24
    @usableFromInline static let endOfMedium: UInt8 = 25
    @usableFromInline static let substitute: UInt8 = 26
    @usableFromInline static let escape: UInt8 = 27
    @usableFromInline static let fileSeparator: UInt8 = 28
    @usableFromInline static let groupSeparator: UInt8 = 29
    @usableFromInline static let recordSeparator: UInt8 = 30
    @usableFromInline static let unitSeparator: UInt8 = 31

    @usableFromInline static let space: UInt8 = 32
    @usableFromInline static let bang: UInt8 = 33
    @usableFromInline static let doubleQuote: UInt8 = 34
    @usableFromInline static let hashTag: UInt8 = 35
    @usableFromInline static let dollarSign: UInt8 = 36
    @usableFromInline static let percentSign: UInt8 = 37
    @usableFromInline static let ampersand: UInt8 = 38
    @usableFromInline static let singleQuote: UInt8 = 39
    @usableFromInline static let parenOpen: UInt8 = 40
    @usableFromInline static let parenClose: UInt8 = 41
    @usableFromInline static let astericks: UInt8 = 42
    @usableFromInline static let plus: UInt8 = 43
    @usableFromInline static let comma: UInt8 = 44
    @usableFromInline static let minus: UInt8 = 45
    @usableFromInline static let dot: UInt8 = 46
    @usableFromInline static let forwardSlash: UInt8 = 47

    @usableFromInline static let zero: UInt8 = 48
    @usableFromInline static let one: UInt8 = 49
    @usableFromInline static let two: UInt8 = 50
    @usableFromInline static let three: UInt8 = 51
    @usableFromInline static let four: UInt8 = 52
    @usableFromInline static let five: UInt8 = 53
    @usableFromInline static let six: UInt8 = 54
    @usableFromInline static let seven: UInt8 = 55
    @usableFromInline static let eight: UInt8 = 56
    @usableFromInline static let nine: UInt8 = 57

    @usableFromInline static let colon: UInt8 = 58
    @usableFromInline static let semiColon: UInt8 = 59
    @usableFromInline static let lessThan: UInt8 = 60
    @usableFromInline static let equal: UInt8 = 61
    @usableFromInline static let greaterThan: UInt8 = 62
    @usableFromInline static let questionMark: UInt8 = 63
    @usableFromInline static let atMark: UInt8 = 64

    @usableFromInline static let A: UInt8 = 65
    @usableFromInline static let B: UInt8 = 66
    @usableFromInline static let C: UInt8 = 67
    @usableFromInline static let D: UInt8 = 68
    @usableFromInline static let E: UInt8 = 69
    @usableFromInline static let F: UInt8 = 70
    @usableFromInline static let G: UInt8 = 71
    @usableFromInline static let H: UInt8 = 72
    @usableFromInline static let I: UInt8 = 73
    @usableFromInline static let J: UInt8 = 74
    @usableFromInline static let K: UInt8 = 75
    @usableFromInline static let L: UInt8 = 76
    @usableFromInline static let M: UInt8 = 77
    @usableFromInline static let N: UInt8 = 78
    @usableFromInline static let O: UInt8 = 79
    @usableFromInline static let P: UInt8 = 80
    @usableFromInline static let Q: UInt8 = 81
    @usableFromInline static let R: UInt8 = 82
    @usableFromInline static let S: UInt8 = 83
    @usableFromInline static let T: UInt8 = 84
    @usableFromInline static let U: UInt8 = 85
    @usableFromInline static let V: UInt8 = 86
    @usableFromInline static let W: UInt8 = 87
    @usableFromInline static let X: UInt8 = 88
    @usableFromInline static let Y: UInt8 = 89
    @usableFromInline static let Z: UInt8 = 90

    @usableFromInline static let openBrace: UInt8 = 91
    @usableFromInline static let backSlash: UInt8 = 92
    @usableFromInline static let closeBrace: UInt8 = 93
    @usableFromInline static let carrat: UInt8 = 94
    @usableFromInline static let underscore: UInt8 = 95
    @usableFromInline static let backtick: UInt8 = 96

    @usableFromInline static let a: UInt8 = 97
    @usableFromInline static let b: UInt8 = 98
    @usableFromInline static let c: UInt8 = 99
    @usableFromInline static let d: UInt8 = 100
    @usableFromInline static let e: UInt8 = 101
    @usableFromInline static let f: UInt8 = 102
    @usableFromInline static let g: UInt8 = 103
    @usableFromInline static let h: UInt8 = 104
    @usableFromInline static let i: UInt8 = 105
    @usableFromInline static let j: UInt8 = 106
    @usableFromInline static let k: UInt8 = 107
    @usableFromInline static let l: UInt8 = 108
    @usableFromInline static let m: UInt8 = 109
    @usableFromInline static let n: UInt8 = 110
    @usableFromInline static let o: UInt8 = 111
    @usableFromInline static let p: UInt8 = 112
    @usableFromInline static let q: UInt8 = 113
    @usableFromInline static let r: UInt8 = 114
    @usableFromInline static let s: UInt8 = 115
    @usableFromInline static let t: UInt8 = 116
    @usableFromInline static let u: UInt8 = 117
    @usableFromInline static let v: UInt8 = 118
    @usableFromInline static let w: UInt8 = 119
    @usableFromInline static let x: UInt8 = 120
    @usableFromInline static let y: UInt8 = 121
    @usableFromInline static let z: UInt8 = 122

    @usableFromInline static let openBracket: UInt8 = 123
    @usableFromInline static let pipe: UInt8 = 124
    @usableFromInline static let closeBracket: UInt8 = 125
    @usableFromInline static let tilde: UInt8 = 126
    @usableFromInline static let del: UInt8 = 127
}
