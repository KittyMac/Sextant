import Foundation
import Hitch
import Spanker

extension PathFunction {

    func invoke(currentPath: Hitch,
                parentPath: Path,
                jsonElement: JsonElement,
                evaluationContext: EvaluationContext,
                parameters: [Parameter]) -> JsonAny {

        switch self {
        case .AVG:
            guard let numerals = numerals(evaluationContext: evaluationContext, jsonElement: jsonElement, parameters: parameters) else {
                return nil
            }
            return numerals.reduce(0.0, +) / Double(numerals.count)
        case .STDDEV:
            guard let numerals = numerals(evaluationContext: evaluationContext, jsonElement: jsonElement, parameters: parameters) else {
                return nil
            }

            let sum = numerals.reduce(0.0, +)
            let sumSq = numerals.reduce(0.0) { $0 + ($1 * $1) }
            let count = Double(numerals.count)

            return sqrt((sumSq / count) - (sum * sum / count / count))
        case .SUM:
            return numerals(evaluationContext: evaluationContext, jsonElement: jsonElement, parameters: parameters)?.reduce(0, +)
        case .MIN:
            return numerals(evaluationContext: evaluationContext, jsonElement: jsonElement, parameters: parameters)?.min()
        case .MAX:
            return numerals(evaluationContext: evaluationContext, jsonElement: jsonElement, parameters: parameters)?.max()
        case .CONCAT:
            guard let hitches = hitches(evaluationContext: evaluationContext, jsonElement: jsonElement, parameters: parameters) else {
                return nil
            }
            let combined = Hitch(capacity: hitches.reduce(0) { $0 + $1.count })
            hitches.forEach { combined.append($0) }
            return combined.description
        case .LENGTH, .SIZE:
            switch jsonElement.type {
            case .dictionary, .array, .string:
                return jsonElement.count
            default:
                return nil
            }

        case .APPEND:
            guard jsonElement.type == .array else { return jsonElement }

            var result = [JsonAny]()
            for element in jsonElement.iterValues {
                result.append(element.reify())
            }
            for param in parameters {
                result.append(param.value(evaluationContext: evaluationContext))
            }
            return result
        }
    }

    func numerals(evaluationContext: EvaluationContext,
                  jsonElement: JsonElement,
                  parameters: [Parameter]) -> [Double]? {
        var values = [Double]()

        if jsonElement.type == .array {
            for element in jsonElement.iterValues {
                if element.type == .int {
                    values.append(Double(element.intValue ?? 0))
                } else if element.type == .double {
                    values.append(element.doubleValue ?? 0.0)
                }
            }
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
                 jsonElement: JsonElement,
                 parameters: [Parameter]) -> [HalfHitch]? {
        var values = [HalfHitch]()

        if jsonElement.type == .array {
            for element in jsonElement.iterValues {
                if let value = element.halfHitchValue {
                    values.append(value)
                }
            }
        }

        values.append(contentsOf: Parameter.halfHitches(evaluationContext: evaluationContext,
                                                        parameters: parameters) ?? [])

        guard values.count > 0  else {
            error("Aggregation function attempted to calculate value using empty array")
            return nil
        }

        return values
    }
}
