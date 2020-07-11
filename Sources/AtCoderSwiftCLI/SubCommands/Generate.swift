import ArgumentParser
import Foundation
import PathKit
import ProjectSpec
import XcodeGenKit
import XcodeProj

extension AtCoderSwiftCommand {
    struct Generate: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Generate AtCoder Project")

        @Argument()
        var projectName: String

        // swift-format-ignore
        @Option(
            name: .shortAndLong,
            help: "Template Swift file path. default: empty Swift file.")
        var templatePath: String?

        func run() throws {
            let generateConfiguration = ABCConfiguration()

            let projectDir = Path.current + Path(projectName)
            let fileContent = templatePath.flatMap({ try? Path($0).read() }) ?? ""

            generateConfiguration.problems.forEach { (problem) in
                do {
                    let dir = projectDir + Path(problem)
                    try dir.mkpath()
                    let mainFile = dir + Path("main.swift")
                    try mainFile.write(fileContent)
                } catch let e {
                    print(e.localizedDescription, printer: .warn)
                    return
                }
            }

            let project: Project = .init(
                basePath: projectDir,
                name: projectName,
                targets: generateConfiguration.targets
            )
            let fileWriter = FileWriter(project: project)

            let xcodeProject: XcodeProj
            do {
                let projectGenerator = ProjectGenerator(project: project)
                xcodeProject = try projectGenerator.generateXcodeProject()
            } catch let e {
                print(e.localizedDescription, printer: .error)
                return
            }

            do {
                try fileWriter.writeXcodeProject(xcodeProject)
            } catch let e {
                print(e.localizedDescription, printer: .warn)
                return
            }
        }
    }
}
