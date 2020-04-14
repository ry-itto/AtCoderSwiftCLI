import ArgumentParser

extension AtCoderSwiftCommand {
    struct Generate: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Generate AtCoder Project")
    }
}
