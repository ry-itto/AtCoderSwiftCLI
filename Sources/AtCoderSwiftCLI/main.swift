import ArgumentParser

struct AtCoderSwiftCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "atcoder-swift",
        abstract: "AtCoder Swift CLI",
        subcommands: [],
        defaultSubcommand: nil)
}

AtCoderSwiftCommand.main()
