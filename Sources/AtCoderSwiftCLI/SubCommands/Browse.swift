import ArgumentParser
import Foundation
import PathKit

extension AtCoderSwiftCommand {
    struct Browse: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Open task",
            discussion: """
                        If project name is 'abc...' or 'agc...' or 'arc...' and specify task,
                        open the task in browser.
                        """
        )

        @Argument()
        var task: String

        func validate() throws {
            let taskPath = Path.current + Path(task)
            guard
                taskPath.extension == nil,
                taskPath.exists
            else {
                throw AtCoderSwiftCLIError(message: "No such task.")
            }
        }

        func run() throws {
            // example: atcoderURL/abc162/tasks/abc162_a
            let projectName = Path.current.lastComponent
            let pathToTask = "\(projectName)/tasks/\(projectName)_\(task)".lowercased()
            let urlString = Constants.contestsURL.appendingPathComponent(pathToTask).absoluteString

            let process = Process()
            process.launchPath = "/usr/bin/open"
            process.arguments = [urlString]
            process.launch()
        }
    }
}
