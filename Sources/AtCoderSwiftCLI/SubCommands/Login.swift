import ArgumentParser
import Foundation
import Fuzi

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
            login(username: username, password: password) { [dispatchGroup] result in
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

        private func login(username: String, password: String, completion: @escaping (Result<Void, AtCoderSwiftCLIError>) -> Void) {
            URLSession.shared.dataTask(with: Constants.loginURL) { data, response, error in
                if let error = error {
                    print(error.localizedDescription, printer: .error)
                    return
                }

                guard
                    let data = data,
                    let document = try? HTMLDocument(data: data)
                else {
                    return
                }
                guard let csrfToken = document.css("input[name=\"csrf_token\"]")
                    .first?
                    .attr("value")
                else {
                    print("csrf_token not found", printer: .error)
                    return
                }

                var urlComponents = URLComponents(url: Constants.loginURL, resolvingAgainstBaseURL: false)
                urlComponents?.queryItems = [
                    .init(name: "username", value: username),
                    .init(name: "password", value: password),
                    .init(name: "csrf_token", value: csrfToken),
                ]
                guard let url = urlComponents?.url else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"

                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription, printer: .error)
                        return
                    }
                    guard
                        let data = data,
                        let document = try? HTMLDocument(data: data)
                    else { return }

                    if let _ = document.css("div.alert-success").first {
                        completion(.success(()))
                    } else if let errorDoc = document.css("div.alert-danger").first {
                        completion(.failure(AtCoderSwiftCLIError(message: errorDoc.stringValue)))
                    }
                }.resume()
            }.resume()

        }

        private func readPassPhrase(prefix: String = "Password: ") -> String? {
            var _password: [Int8] = .init(repeating: 0, count: 128)
            if let passPhrase = readpassphrase(prefix, &_password, _password.count, 0),
                let password = String(validatingUTF8: passPhrase) {
                return password
            }
            return nil
        }
    }
}
