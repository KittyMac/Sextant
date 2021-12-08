import Foundation
import Hitch

typealias PathFunctionNumberBlock = (Double) -> Void
typealias PathFunctionStringBlock = (String) -> Void

private let functionAVG = Hitch("avg()")
private let functionSTDDEV = Hitch("stddev()")
private let functionSUM = Hitch("sum()")
private let functionMIN = Hitch("min()")
private let functionMAX = Hitch("max()")
private let functionCONCAT = Hitch("concat()")
private let functionLENGTH = Hitch("length()")
private let functionSIZE = Hitch("size()")
private let functionAPPEND = Hitch("append()")

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
        switch hitch {
        case functionAVG:
            self = .AVG
        case functionSTDDEV:
            self = .STDDEV
        case functionSUM:
            self = .SUM
        case functionMIN:
            self = .MIN
        case functionMAX:
            self = .MAX
        case functionCONCAT:
            self = .CONCAT
        case functionLENGTH:
            self = .LENGTH
        case functionSIZE:
            self = .SIZE
        case functionAPPEND:
            self = .APPEND
        default:
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
            guard let numerals = numerals(jsonObject: jsonObject, parameters: parameters) else {
                return nil
            }
            return numerals.reduce(0.0, +) / Double(numerals.count)
        case .STDDEV:
            guard let numerals = numerals(jsonObject: jsonObject, parameters: parameters) else {
                return nil
            }
            
            let sum = numerals.reduce(0.0, +)
            let sumSq = numerals.reduce(0.0) { $0 + ($1 * $1) }
            let count = Double(numerals.count)
            
            return sqrt((sumSq / count) - (sum * sum / count / count))
        case .SUM:
            return numerals(jsonObject: jsonObject, parameters: parameters)?.reduce(0, +)
        case .MIN:
            return numerals(jsonObject: jsonObject, parameters: parameters)?.min()
        case .MAX:
            return numerals(jsonObject: jsonObject, parameters: parameters)?.max()
        case .CONCAT:
            fatalError("TO BE IMPLEMENTED")
        case .LENGTH:
            fatalError("TO BE IMPLEMENTED")
        case .SIZE:
            fatalError("TO BE IMPLEMENTED")
        case .APPEND:
            fatalError("TO BE IMPLEMENTED")
        }
    }
    
    func numerals(jsonObject: JsonAny,
                  parameters: [Parameter]) -> [Double]? {
        var values = [Double]()
        
        if let array = jsonObject as? JsonArray {
            values.append(contentsOf: array.compactMap { $0 as? Double })
        }
        
        values.append(contentsOf: parameters.compactMap { $0.value() as? Double })
        
        guard values.count > 0  else {
            error("Aggregation function attempted to calculate value using empty array")
            return nil
        }
        
        return values
    }
}
