import Foundation
import Hitch

typealias ParameterLateBinding = ((Parameter) -> JsonAny)

final class Parameter {
    var uuid: Int = 0

    var json: Hitch?
    var path: Path?
    //var cachedValue: JsonAny = nil
    //var lateBinding: ParameterLateBinding?

    init(json: Hitch) {
        self.json = Hitch(hitch: json)
        uuid = unsafeBitCast(self, to: Int.self)
    }

    init(path: Path) {
        uuid = unsafeBitCast(self, to: Int.self)
        self.path = path
    }

    func value(evaluationContext: EvaluationContext) -> JsonAny {
        if let cachedValue = evaluationContext.evaluatedParametersCache[uuid] {
            return cachedValue
        }
        if let lateBinding = evaluationContext.evaluatedParametersBindings[uuid] {
            let value = lateBinding?(self)
            evaluationContext.evaluatedParametersCache[uuid] = value
            return value
        }
        return nil
    }

    class func doubles(evaluationContext: EvaluationContext,
                       parameters: [Parameter]) -> [Double]? {
        var values = [Double]()

        let handle: (JsonAny) -> Void = { obj in
            if let typedValue = obj.toDouble() {
                values.append(typedValue)
            }
        }

        for param in parameters {
            guard let value = param.value(evaluationContext: evaluationContext) else { return nil }

            if let array = value as? JsonArray {
                array.forEach(handle)
            } else {
                handle(value)
            }
        }

        return values
    }

    class func halfHitches(evaluationContext: EvaluationContext,
                           parameters: [Parameter]) -> [HalfHitch]? {
        var values = [HalfHitch]()

        let handle: (JsonAny) -> Void = { obj in
            if let typedValue = obj.toHalfHitch() {
                values.append(typedValue)
            } else if let typedValue = obj.toInt() {
                values.append("{0}" << [typedValue])
            } else if let typedValue = obj.toDouble() {
                values.append("{0}" << [typedValue])
            } else if let typedValue = obj.toBool() {
                values.append("{0}" << [typedValue])
            }
        }

        for param in parameters {
            guard let value = param.value(evaluationContext: evaluationContext) else { return nil }

            if let array = value as? JsonArray {
                array.forEach(handle)
            } else {
                handle(value)
            }
        }

        return values
    }

    class func hitches(evaluationContext: EvaluationContext,
                       parameters: [Parameter]) -> [Hitch]? {
        var values = [Hitch]()

        let handle: (JsonAny) -> Void = { obj in
            if let typedValue = obj.toHitch() {
                values.append(typedValue)
            } else if let typedValue = obj.toInt() {
                values.append("{0}" <<< [typedValue])
            } else if let typedValue = obj.toDouble() {
                values.append("{0}" <<< [typedValue])
            } else if let typedValue = obj.toBool() {
                values.append("{0}" <<< [typedValue])
            }
        }

        for param in parameters {
            guard let value = param.value(evaluationContext: evaluationContext) else { return nil }

            if let array = value as? JsonArray {
                array.forEach(handle)
            } else {
                handle(value)
            }
        }

        return values
    }

}
