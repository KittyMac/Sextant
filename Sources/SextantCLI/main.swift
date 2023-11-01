import Foundation
import Hitch
import Spanker
import Chronometer
import ArgumentParser
import Sextant

struct SextantCLI: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "Store files resources in Swift code",
        subcommands: [Query.self],
        defaultSubcommand: Query.self)
    
    struct Query: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "run JSONPath queries and output the results")
        
        @Argument(help: "JSON path query")
        var path: String
        
        @Option(name: .customShort("p"), help: "JSON path queries to run")
        var paths: [String] = []
        
        @Option(name: .customShort("f"), help: "Path to individual JSON files or directories containing JSON files")
        var files: [String]
        
        @Flag(help: "Output the path to the results instead of the results themselves")
        var printPaths: Bool = false
        
        @Flag(help: "Pretty print the results JSON")
        var printPretty: Bool = false

                        
        mutating func run() throws {
            // gather all JSON files into a new array
            var jsonFiles: [String] = []
            func addJsonFile(_ file: String) throws {
                guard file.hasSuffix(".json") else { return }
                guard FileManager.default.fileExists(atPath: file) else {
                    throw ValidationError("File does not exist at \(file)")
                }
                jsonFiles.append(file)
            }
            
            for file in files {
                var isDirectory: ObjCBool = false
                guard FileManager.default.fileExists(atPath: file, isDirectory: &isDirectory) else {
                    throw ValidationError("File does not exist at \(file)")
                }
                if isDirectory.boolValue == true {
                    guard let otherFiles = try? FileManager.default.contentsOfDirectory(atPath: file) else {
                        throw ValidationError("Failed to list contents of directory at \(file)")
                    }
                    for otherFile in otherFiles {
                        try addJsonFile("\(file)/\(otherFile)")
                    }
                } else {
                    try addJsonFile(file)
                }
            }
            
            paths.append(path)
            
            let jsonPaths = paths.map { Hitch(string: $0) }
            
            for jsonFile in jsonFiles {
                guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFile)) else {
                    throw CleanExit.message("Failed to read \(jsonFile)")
                }
                
                jsonData.parsed { root in
                    guard let root = root else { fatalError("Failed to parse \(jsonFile)") }
                    
                    if printPaths {
                        if let results = root.query(paths: jsonPaths) {
                            let combined = ^[]
                            for result in results {
                                combined.append(value: result)
                            }
                            print("\(jsonFile):")
                            print(combined.toHitch(pretty: printPretty))
                        }
                    } else {
                        if let results = root.query(elements: jsonPaths) {
                            let combined = ^[]
                            for result in results {
                                combined.append(value: result)
                            }
                            print("\(jsonFile):")
                            print(combined.toHitch(pretty: printPretty))
                        }
                    }
                }
            }
        }
    }
}

SextantCLI.main()
