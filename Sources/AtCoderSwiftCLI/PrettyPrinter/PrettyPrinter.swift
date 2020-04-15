import Rainbow

enum PrettyPrinter {
    case info
    case warn
    case error

    var tag: String {
        switch self {
        case .info:
            return "[INFO]"
        case .warn:
            return "[WARN]"
        case .error:
            return "[ERROR]"
        }
    }

    var tagWithColor: String {
        tag.applyingColor(color)
    }

    var color: Color {
        switch self {
        case .info:
            return .lightGreen
        case .warn:
            return .lightYellow
        case .error:
            return .red
        }
    }
}

extension String {
    func applyPrinter(_ printer: PrettyPrinter) -> String {
        "\(printer.tagWithColor) \(self)"
    }
}

func print(_ printString: String, printer: PrettyPrinter) {
    print(printString.applyPrinter(printer))
}
