import Foundation
import Hitch

typealias ParameterLateBinding = ((Parameter) -> JsonAny)

final class Parameter {
    var evaluated: Bool = false
    var json: Hitch?
    var path: Path?
    var cachedValue: JsonAny = nil
    var lateBinding: ParameterLateBinding?

    init(json: Hitch) {
        self.json = Hitch(hitch: json)
    }

    init(path: Path) {
        self.path = path
    }

    func value() -> JsonAny {
        if let cachedValue = cachedValue {
            return cachedValue
        }
        if let lateBinding = lateBinding {
            cachedValue = lateBinding(self)
        }
        return cachedValue
    }

    class func doubles(parameters: [Parameter]) -> [Double]? {
        var values = [Double]()

        let handle: (JsonAny) -> Void = { obj in
            if let typedValue = obj.toDouble() {
                values.append(typedValue)
            }
        }

        for param in parameters {
            guard let value = param.value() else { return nil }

            if let array = value as? JsonArray {
                array.forEach(handle)
            } else {
                handle(value)
            }
        }

        return values
    }

    class func halfHitches(parameters: [Parameter]) -> [HalfHitch]? {
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
            guard let value = param.value() else { return nil }

            if let array = value as? JsonArray {
                array.forEach(handle)
            } else {
                handle(value)
            }
        }

        return values
    }

    class func hitches(parameters: [Parameter]) -> [Hitch]? {
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
            guard let value = param.value() else { return nil }

            if let array = value as? JsonArray {
                array.forEach(handle)
            } else {
                handle(value)
            }
        }

        return values
    }

}
