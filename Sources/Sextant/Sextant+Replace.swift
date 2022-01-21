import Foundation
import Hitch
import Spanker

public typealias PerformUpdateResult = (JsonElement) -> Void

// MARK: - Incoming Extensions - Query

public extension String {
    // @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: path, with: value, callback) }

    // @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
}

public extension Hitch {
    // @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: path, with: value, callback) }

    // @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
}

public extension Data {
    // @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: path, with: value, callback) }

    // @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
}

/*
public extension JsonAny {
    // @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: path, with: value, callback) }

    // @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
}*/

public extension JsonElement {
    // @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @discardableResult @inlinable func query(replace path: Hitch, with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: path, with: value) }

    // @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @discardableResult @inlinable func query(replace path: String, with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value) }
}

/*
public extension Array {
    // @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: path, with: value, callback) }

    // @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
}

public extension Dictionary {
    // @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: path, with: value, callback) }

    // @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) -> JsonAny { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
}
*/

public extension Sextant {

    func query(_ root: JsonElement,
               replace path: Hitch,
               with value: JsonAny) -> JsonElement? {
        guard let path = cachedPath(query: path) else { return nil }
        if let results = path.evaluate(jsonElement: root,
                                       rootJsonElement: root,
                                       options: [.updateOperation]) {

            for operation in results.updateOperations {
                operation.set(value: value)
            }

            return root
        }
        return nil
    }
/*
    func query(_ root: JsonAny,
               replace path: Hitch,
               with value: JsonAny) -> JsonAny {
        guard let path = cachedPath(query: path) else { return nil }
        if let results = path.evaluate(jsonObject: root,
                                       rootJsonObject: root,
                                       options: [.updateOperation]) {

            for operation in results.updateOperations {
                operation.set(value: value)
            }

            return root
        }
        return nil
    }
*/
    /*
    func query(_ root: JsonElement?,
               replace pathArray: [Hitch],
               with value: JsonAny) -> JsonAny {
        var numFails = 0
        for path in pathArray {
            if query(root, replace: path, with: value) == nil {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        return root
    }*/
/*
    func query(_ root: JsonAny,
               replace pathArray: [Hitch],
               with value: JsonAny) -> JsonAny {
        var numFails = 0
        for path in pathArray {
            if query(root, replace: path, with: value) == nil {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        return root
    }*/
}

public extension Sextant {

    @inlinable func query(_ root: String,
                          replace path: Hitch,
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        if shouldUseSpanker {
            root.parsed { jsonData in
                if let jsonData = jsonData,
                   let results = query(jsonData,
                                       replace: path,
                                       with: value) {
                    callback(results)
                }
            }
        } else {
            fatalError("TO BE IMPLEMENTED")
            // guard let jsonData = root.jsonDeserialized() else { return nil }
            // return query(jsonData, replace: path, with: value)
        }
    }

    @inlinable func query(_ root: Hitch,
                          replace path: Hitch,
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        if shouldUseSpanker {
            root.parsed { jsonData in
                if let jsonData = jsonData,
                   let results = query(jsonData,
                                       replace: path,
                                       with: value) {
                    callback(results)
                }
            }
        } else {
            fatalError("TO BE IMPLEMENTED")
            // guard let jsonData = root.jsonDeserialized() else { return nil }
            // return query(jsonData, replace: path, with: value)
        }
    }

    @inlinable func query(_ root: Data,
                          replace path: Hitch,
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        if shouldUseSpanker {
            root.parsed { jsonData in
                if let jsonData = jsonData,
                   let results = query(jsonData,
                                       replace: path,
                                       with: value) {
                    callback(results)
                }
            }
        } else {
            fatalError("TO BE IMPLEMENTED")
            // guard let jsonData = root.jsonDeserialized() else { return nil }
            // return query(jsonData, replace: path, with: value)
        }
    }

}
