import Foundation
import Hitch
import Spanker

// MARK: - Incoming Extensions - Query

public extension String {
    @inlinable func query<T>(replace paths: [Hitch], with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query<T>(replace path: Hitch, with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: path, with: value, callback) }
    @inlinable func query<T>(forEach paths: [Hitch], _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: paths, block, callback) }
    @inlinable func query<T>(forEach path: Hitch, _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: path, block, callback) }
    @inlinable func query<T>(filter paths: [Hitch], _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths, block, callback) }
    @inlinable func query<T>(filter path: Hitch, _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: path, block, callback) }
    @inlinable func query<T>(remove paths: [Hitch], _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths, { _ in false }, callback) }
    @inlinable func query<T>(remove path: Hitch, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: path, { _ in false }, callback) }

    @inlinable func query<T>(replace paths: [String], with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query<T>(replace path: String, with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
    @inlinable func query<T>(forEach paths: [String], _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query<T>(forEach path: String, _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block, callback) }
    @inlinable func query<T>(filter paths: [String], _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query<T>(filter path: String, _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), block, callback) }
    @inlinable func query<T>(remove paths: [String], _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, { _ in false }, callback) }
    @inlinable func query<T>(remove path: String, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), { _ in false }, callback) }
}

public extension Hitch {
    @inlinable func query<T>(replace paths: [Hitch], with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query<T>(replace path: Hitch, with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: path, with: value, callback) }
    @inlinable func query<T>(forEach paths: [Hitch], _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: paths, block, callback) }
    @inlinable func query<T>(forEach path: Hitch, _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: path, block, callback) }
    @inlinable func query<T>(filter paths: [Hitch], _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths, block, callback) }
    @inlinable func query<T>(filter path: Hitch, _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: path, block, callback) }
    @inlinable func query<T>(remove paths: [Hitch], _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths, { _ in false }, callback) }
    @inlinable func query<T>(remove path: Hitch, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: path, { _ in false }, callback) }

    @inlinable func query<T>(replace paths: [String], with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query<T>(replace path: String, with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
    @inlinable func query<T>(forEach paths: [String], _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query<T>(forEach path: String, _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block, callback) }
    @inlinable func query<T>(filter paths: [String], _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query<T>(filter path: String, _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), block, callback) }
    @inlinable func query<T>(remove paths: [String], _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, { _ in false }, callback) }
    @inlinable func query<T>(remove path: String, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), { _ in false }, callback) }
}

public extension Data {
    @inlinable func query<T>(replace paths: [Hitch], with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: paths, with: value, callback) }
    @inlinable func query<T>(replace path: Hitch, with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: path, with: value, callback) }
    @inlinable func query<T>(forEach paths: [Hitch], _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: paths, block, callback) }
    @inlinable func query<T>(forEach path: Hitch, _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: path, block, callback) }
    @inlinable func query<T>(filter paths: [Hitch], _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths, block, callback) }
    @inlinable func query<T>(filter path: Hitch, _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: path, block, callback) }
    @inlinable func query<T>(remove paths: [Hitch], _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths, { _ in false }, callback) }
    @inlinable func query<T>(remove path: Hitch, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: path, { _ in false }, callback) }

    @inlinable func query<T>(replace paths: [String], with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value, callback) }
    @inlinable func query<T>(replace path: String, with value: JsonAny, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value, callback) }
    @inlinable func query<T>(forEach paths: [String], _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query<T>(forEach path: String, _ block: ForEachObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block, callback) }
    @inlinable func query<T>(filter paths: [String], _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, block, callback) }
    @inlinable func query<T>(filter path: String, _ block: FilterObjectBlock, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), block, callback) }
    @inlinable func query<T>(remove paths: [String], _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, { _ in false }, callback) }
    @inlinable func query<T>(remove path: String, _ callback: (JsonElement) -> T?) -> T? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), { _ in false }, callback) }
}

public extension JsonElement {
    @inlinable func query(replace paths: [Hitch], with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: paths, with: value) }
    @discardableResult @inlinable func query(replace path: Hitch, with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: path, with: value) }
    @inlinable func query(forEach paths: [Hitch], _ block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: paths, block) }
    @discardableResult @inlinable func query(forEach path: Hitch, _ block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: path, block) }
    @inlinable func query(filter paths: [Hitch], _ block: FilterObjectBlock) -> JsonElement? { return Sextant.shared.query(self, filter: paths, block) }
    @discardableResult @inlinable func query(filter path: Hitch, _ block: FilterObjectBlock) -> JsonElement? { return Sextant.shared.query(self, filter: path, block) }
    @inlinable func query(remove paths: [Hitch]) -> JsonElement? { return Sextant.shared.query(self, filter: paths, { _ in false }) }
    @discardableResult @inlinable func query(remove path: Hitch) -> JsonElement? { return Sextant.shared.query(self, filter: path, { _ in false }) }

    @inlinable func query(replace paths: [String], with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: paths.map { Hitch(stringLiteral: $0) }, with: value) }
    @discardableResult @inlinable func query(replace path: String, with value: JsonAny) -> JsonElement? { return Sextant.shared.query(self, replace: Hitch(stringLiteral: path), with: value) }
    @inlinable func query(forEach paths: [String], _ block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: paths.map { Hitch(stringLiteral: $0) }, block) }
    @discardableResult @inlinable func query(forEach path: String, _ block: ForEachObjectBlock) -> JsonElement? { return Sextant.shared.query(self, forEach: Hitch(stringLiteral: path), block) }
    @inlinable func query(filter paths: [String], _ block: FilterObjectBlock) -> JsonElement? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, block) }
    @discardableResult @inlinable func query(filter path: String, _ block: FilterObjectBlock) -> JsonElement? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), block) }
    @inlinable func query(remove paths: [String]) -> JsonElement? { return Sextant.shared.query(self, filter: paths.map { Hitch(stringLiteral: $0) }, { _ in false }) }
    @discardableResult @inlinable func query(remove path: String) -> JsonElement? { return Sextant.shared.query(self, filter: Hitch(stringLiteral: path), { _ in false }) }
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

    @discardableResult
    @inlinable func query<T>(_ root: String,
                             replace path: Hitch,
                             with value: JsonAny,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: path,
                                   with: value) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Hitch,
                             replace path: Hitch,
                             with value: JsonAny,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: path,
                                   with: value) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Data,
                             replace path: Hitch,
                             with value: JsonAny,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: path,
                                   with: value) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: String,
                             replace paths: [Hitch],
                             with value: JsonAny,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: paths,
                                   with: value) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Hitch,
                             replace paths: [Hitch],
                             with value: JsonAny,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: paths,
                                   with: value) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Data,
                             replace paths: [Hitch],
                             with value: JsonAny,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   replace: paths,
                                   with: value) {
                return callback(results)
            }
            return nil
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

    @discardableResult
    @inlinable func query<T>(_ root: String,
                             forEach path: Hitch,
                             _ block: ForEachObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: path,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Hitch,
                             forEach path: Hitch,
                             _ block: ForEachObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: path,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Data,
                             forEach path: Hitch,
                             _ block: ForEachObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: path,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: String,
                             forEach paths: [Hitch],
                             _ block: ForEachObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: paths,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Hitch,
                             forEach paths: [Hitch],
                             _ block: ForEachObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: paths,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Data,
                             forEach paths: [Hitch],
                             _ block: ForEachObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   forEach: paths,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }
}

// MARK: - FILTER

public extension Sextant {
    func query(_ root: JsonElement,
               filter path: Hitch,
               _ block: FilterObjectBlock) -> JsonElement? {
        guard let path = cachedPath(query: path) else { return nil }
        if let results = path.evaluate(jsonElement: root,
                                       rootJsonElement: root,
                                       options: [.updateOperation]) {

            results.updateOperations.sort { lhs, rhs in
                if lhs.parentElement != nil &&
                    lhs.parentElement == rhs.parentElement {
                    return lhs.index > rhs.index
                }
                return false
            }

            for operation in results.updateOperations {
                operation.filter(block: block)
            }

            return root
        }
        return nil
    }

    func query(_ root: JsonElement,
               filter pathArray: [Hitch],
               _ block: FilterObjectBlock) -> JsonElement? {
        var numFails = 0
        for path in pathArray {
            if query(root, filter: path, block) == nil {
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

    @discardableResult
    @inlinable func query<T>(_ root: String,
                             filter path: Hitch,
                             _ block: FilterObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   filter: path,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Hitch,
                             filter path: Hitch,
                             _ block: FilterObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   filter: path,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Data,
                             filter path: Hitch,
                             _ block: FilterObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   filter: path,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: String,
                             filter paths: [Hitch],
                             _ block: FilterObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   filter: paths,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Hitch,
                             filter paths: [Hitch],
                             _ block: FilterObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   filter: paths,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }

    @discardableResult
    @inlinable func query<T>(_ root: Data,
                             filter paths: [Hitch],
                             _ block: FilterObjectBlock,
                             _ callback: (JsonElement) -> T?) -> T? {
        return root.parsed { jsonData in
            if let jsonData = jsonData,
               let results = query(jsonData,
                                   filter: paths,
                                   block) {
                return callback(results)
            }
            return nil
        }
    }
}
