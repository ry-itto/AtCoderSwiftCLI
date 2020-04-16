import ProjectSpec

protocol Configuration {
    var problems: [String] { get }
}

extension Configuration {
    var targets: [Target] {
        problems.map { (problem) -> Target in
            Target(
                name: problem,
                type: .commandLineTool,
                platform: .macOS,
                sources: [.init(path: problem)])
        }
    }
}
