import ArgumentParser
import Foundation

extension AtCoderSwiftCommand {
    struct Login: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Login to AtCoder"
        )

        func run() throws {
            print("Username: ", terminator: "")
            let username = readLine() ?? ""
            let password = readPassPhrase() ?? ""
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            AtCoder.login(username: username, password: password) { [dispatchGroup] result in
                defer {
                    dispatchGroup.leave()
                }
                switch result {
                case .success:
                    print("Success!", printer: .info)
                case .failure(let e):
                    print(e.message, printer: .error)
                }
            }
            dispatchGroup.wait()
        }

        private func readPassPhrase(prefix: String = "Password: ") -> String? {
            var _password: [Int8] = .init(repeating: 0, count: 128)
            if let passPhrase = readpassphrase(prefix, &_password, _password.count, 0),
                let password = String(validatingUTF8: passPhrase)
            {
                return password
            }
            return nil
        }
    }
}
