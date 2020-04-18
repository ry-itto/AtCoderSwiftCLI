struct AtCoderSwiftCLIError: Error, CustomStringConvertible {
    let message: String

    var description: String {
        "\(PrettyPrinter.error.tagWithColor) \(message)"
    }
}
