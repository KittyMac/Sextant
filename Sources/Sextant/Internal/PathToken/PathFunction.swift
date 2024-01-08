import Foundation
import Hitch

typealias PathFunctionNumberBlock = (Double) -> Void
typealias PathFunctionStringBlock = (String) -> Void

private let functionAVG = Hitch("avg")
private let functionSTDDEV = Hitch("stddev")
private let functionSUM = Hitch("sum")
private let functionMIN = Hitch("min")
private let functionMAX = Hitch("max")
private let functionCONCAT = Hitch("concat")
private let functionLENGTH = Hitch("length")
private let functionSIZE = Hitch("size")
private let functionAPPEND = Hitch("append")

enum PathFunction {
    case AVG
    case STDDEV
    case SUM
    case MIN
    case MAX
    case CONCAT
    case LENGTH
    case SIZE
    case APPEND

    func hitch() -> Hitch {
        switch self {
        case .AVG:
            return functionAVG
        case .STDDEV:
            return functionSTDDEV
        case .SUM:
            return functionSUM
        case .MIN:
            return functionMIN
        case .MAX:
            return functionMAX
        case .CONCAT:
            return functionCONCAT
        case .LENGTH:
            return functionLENGTH
        case .SIZE:
            return functionSIZE
        case .APPEND:
            return functionAPPEND
        }
    }

    init?(hitch: Hitch) {
        if hitch.lowercase().starts(with: functionAVG) {
            self = .AVG
        } else if hitch.starts(with: functionSTDDEV) {
            self = .STDDEV
        } else if hitch.starts(with: functionSUM) {
            self = .SUM
        } else if hitch.starts(with: functionMIN) {
            self = .MIN
        } else if hitch.starts(with: functionMAX) {
            self = .MAX
        } else if hitch.starts(with: functionCONCAT) {
            self = .CONCAT
        } else if hitch.starts(with: functionLENGTH) {
            self = .LENGTH
        } else if hitch.starts(with: functionSIZE) {
            self = .SIZE
        } else if hitch.starts(with: functionAPPEND) {
            self = .APPEND
        } else {
            return nil
        }
    }

    func invoke(currentPath: Hitch,
                parentPath: Path,
                jsonObject: JsonAny,
                evaluationContext: EvaluationContext,
                parameters: [Parameter]) -> JsonAny {

        switch self {
        case .AVG:
            guard let numerals = numerals(evaluationContext: evaluationContext, jsonObject: jsonObject, parameters: parameters) else {
                return nil
            }
            return numerals.reduce(0.0, +) / Double(numerals.count)
        case .STDDEV:
            guard let numerals = numerals(evaluationContext: evaluationContext, jsonObject: jsonObject, parameters: parameters) else {
                return nil
            }

            let sum = numerals.reduce(0.0, +)
            let sumSq = numerals.reduce(0.0) { $0 + ($1 * $1) }
            let count = Double(numerals.count)

            return sqrt((sumSq / count) - (sum * sum / count / count))
        case .SUM:
            return numerals(evaluationContext: evaluationContext, jsonObject: jsonObject, parameters: parameters)?.reduce(0, +)
        case .MIN:
            return numerals(evaluationContext: evaluationContext, jsonObject: jsonObject, parameters: parameters)?.min()
        case .MAX:
            return numerals(evaluationContext: evaluationContext, jsonObject: jsonObject, parameters: parameters)?.max()
        case .CONCAT:
            guard let hitches = hitches(evaluationContext: evaluationContext, jsonObject: jsonObject, parameters: parameters) else {
                return nil
            }
            let combined = Hitch(capacity: hitches.reduce(0) { $0 + $1.count })
            hitches.forEach { combined.append($0) }
            return combined.description
        case .LENGTH, .SIZE:
            if let array = jsonObject as? JsonArray {
                return array.count
            }
            if let dictionary = jsonObject as? JsonDictionary {
                return dictionary.count
            }
            if let hitch = jsonObject as? Hitch {
                return hitch.count
            }
            if let hitch = jsonObject as? HalfHitch {
                return hitch.count
            }
            if let string = jsonObject as? String {
                return string.count
            }
            return nil

        case .APPEND:
            guard let array = jsonObject as? JsonArray else { return jsonObject }

            var result = [JsonAny]()
            result.append(contentsOf: array)
            for param in parameters {
                result.append(param.value(evaluationContext: evaluationContext))
            }
            return result
        }
    }

    func numerals(evaluationContext: EvaluationContext,
                  jsonObject: JsonAny,
                  parameters: [Parameter]) -> [Double]? {
        var values = [Double]()

        if let array = jsonObject as? JsonArray {
            values.append(contentsOf: array.compactMap { $0.toDouble() })
        }

        values.append(contentsOf: Parameter.doubles(evaluationContext: evaluationContext,
                                                    parameters: parameters) ?? [])

        guard values.count > 0  else {
            error("Aggregation function attempted to calculate value using empty array")
            return nil
        }

        return values
    }

    func hitches(evaluationContext: EvaluationContext,
                 jsonObject: JsonAny,
                 parameters: [Parameter]) -> [Hitch]? {
        var values = [Hitch]()

        if let array = jsonObject as? JsonArray {
            values.append(contentsOf: array.compactMap { $0.toHitch() })
        }

        values.append(contentsOf: Parameter.hitches(evaluationContext: evaluationContext,
                                                    parameters: parameters) ?? [])

        guard values.count > 0  else {
            error("Aggregation function attempted to calculate value using empty array")
            return nil
        }

        return values
    }
}
