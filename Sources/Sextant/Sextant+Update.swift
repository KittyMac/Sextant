import Foundation
import Hitch
import Spanker

public typealias PerformUpdateResult = (JsonElement) -> Void

// MARK: - Incoming Extensions - Query

public extension String {
    @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: path, with: value, callback) }
    @inlinable func query(forEach paths: [Hitch], _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: paths, block, callback) }
    @inlinable func query(forEach path: Hitch, _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: path, block, callback) }

    @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
    @inlinable func query(forEach paths: [String], _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query(forEach path: String, _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block, callback) }
}

public extension Hitch {
    @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: path, with: value, callback) }
    @inlinable func query(forEach paths: [Hitch], _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: paths, block, callback) }
    @inlinable func query(forEach path: Hitch, _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: path, block, callback) }

    @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
    @inlinable func query(forEach paths: [String], _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query(forEach path: String, _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block, callback) }
}

public extension Data {
    @inlinable func query(replace paths: [Hitch], with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query(replace path: Hitch, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: path, with: value, callback) }
    @inlinable func query(forEach paths: [Hitch], _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: paths, block, callback) }
    @inlinable func query(forEach path: Hitch, _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: path, block, callback) }

    @inlinable func query(replace paths: [String], with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query(replace path: String, with value: JsonAny, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
    @inlinable func query(forEach paths: [String], _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query(forEach path: String, _ block: ForEachObjectBlock, _ callback: PerformUpdateResult) { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block, callback) }
}

public extension JsonElement {
    @inlinable func query(replace paths: [Hitch], with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: paths, with: value) }
    @discardableResult @inlinable func query(replace path: Hitch, with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: path, with: value) }
    @inlinable func query(forEach paths: [Hitch], _ block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: paths, block) }
    @discardableResult @inlinable func query(forEach path: Hitch, each block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: path, block) }

    @inlinable func query(replace paths: [String], with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value) }
    @discardableResult @inlinable func query(replace path: String, with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value) }
    @inlinable func query(forEach paths: [String], _ block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block) }
    @discardableResult @inlinable func query(forEach path: String, each block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block) }
}

// MARK: - REPLACE

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

    func query(_ root: JsonElement,
               replace pathArray: [Hitch],
               with value: JsonAny) -> JsonElement? {
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
    }
}

public extension Sextant {

    @inlinable func query(_ root: String,
                          replace path: Hitch,
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: path,
                                   with: value) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Hitch,
                          replace path: Hitch,
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: path,
                                   with: value) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Data,
                          replace path: Hitch,
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: path,
                                   with: value) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: String,
                          replace paths: [Hitch],
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: paths,
                                   with: value) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Hitch,
                          replace paths: [Hitch],
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: paths,
                                   with: value) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Data,
                          replace paths: [Hitch],
                          with value: JsonAny,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: paths,
                                   with: value) {
                callback(results)
            }
        }
    }
}

// MARK: - FOREACH

public extension Sextant {
    func query(_ root: JsonElement,
               forEach path: Hitch,
               _ block: ForEachObjectBlock) -> JsonElement? {
        guard let path = cachedPath(query: path) else { return nil }
        if let results = path.evaluate(jsonElement: root,
                                       rootJsonElement: root,
                                       options: [.updateOperation]) {

            for operation in results.updateOperations {
                operation.forEach(block: block)
            }

            return root
        }
        return nil
    }

    func query(_ root: JsonElement,
               forEach pathArray: [Hitch],
               _ block: ForEachObjectBlock) -> JsonElement? {
        var numFails = 0
        for path in pathArray {
            if query(root, forEach: path, block) == nil {
                numFails += 1
            }
        }
        if numFails == pathArray.count {
            return nil
        }
        return root
    }
}

public extension Sextant {

    @inlinable func query(_ root: String,
                          forEach path: Hitch,
                          _ block: ForEachObjectBlock,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: path,
                                   block) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Hitch,
                          forEach path: Hitch,
                          _ block: ForEachObjectBlock,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: path,
                                   block) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Data,
                          forEach path: Hitch,
                          _ block: ForEachObjectBlock,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: path,
                                   block) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: String,
                          forEach paths: [Hitch],
                          _ block: ForEachObjectBlock,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: paths,
                                   block) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Hitch,
                          forEach paths: [Hitch],
                          _ block: ForEachObjectBlock,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: paths,
                                   block) {
                callback(results)
            }
        }
    }

    @inlinable func query(_ root: Data,
                          forEach paths: [Hitch],
                          _ block: ForEachObjectBlock,
                          _ callback: PerformUpdateResult) {
        root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: paths,
                                   block) {
                callback(results)
            }
        }
    }
}
