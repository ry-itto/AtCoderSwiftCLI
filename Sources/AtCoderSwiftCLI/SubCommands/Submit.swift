import ArgumentParser
import Foundation

extension AtCoderSwiftCommand {
    struct Submit: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Submit your answer."
        )

        @Argument(help:"A problem such as \"a\"")
        var problem: String

        func run() throws {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            AtCoder.submit(problem: problem) { result in
                defer {
                    dispatchGroup.leave()
                }
                switch result {
                case .success:
                    print("Submit success!", printer: .info)
                case .failure(let e):
                    print(e.message, printer: .error)
                }
            }
            dispatchGroup.wait()
        }
    }
}
