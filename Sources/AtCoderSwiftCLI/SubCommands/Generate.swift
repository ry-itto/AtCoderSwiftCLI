import ArgumentParser
import Foundation
import ProjectSpec
import XcodeProj
import XcodeGenKit

extension AtCoderSwiftCommand {
    struct Generate: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Generate AtCoder Project")

        @Argument()
        var projectName: String

        func run() throws {
            let generateConfiguration = ABCConfiguration()
            let project: Project = .init(
                name: projectName,
                targets: generateConfiguration.targets
            )
            let fileWriter = FileWriter(project: project)

            let xcodeProject: XcodeProj
            do {
                let projectGenerator = ProjectGenerator(project: project)
                xcodeProject = try projectGenerator.generateXcodeProject()
            } catch {
                return
            }

            do {
                try fileWriter.writeXcodeProject(xcodeProject)
            } catch {
                return
            }
        }
    }
}
