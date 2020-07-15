import ArgumentParser

extension AtCoderSwiftCommand {
    struct Submit: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Submit your answer."
        )

        @Argument(help:"A problem such as \"a\"")
        var problem: String

        func run() throws {
            AtCoder.submit(problem: problem)
        }
    }
}
