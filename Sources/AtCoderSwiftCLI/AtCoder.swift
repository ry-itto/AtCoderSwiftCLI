import Foundation
import Fuzi
import PathKit

struct AtCoder {
    static func login(
        username: String, password: String,
        completion: @escaping (Result<Void, AtCoderSwiftCLIError>) -> Void
    ) {
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
            guard
                let csrfToken = document.css("input[name=\"csrf_token\"]")
                    .first?
                    .attr("value")
            else {
                print("csrf_token not found", printer: .error)
                return
            }

            var urlComponents = URLComponents(
                url: Constants.loginURL, resolvingAgainstBaseURL: false)
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

    static func loggedIn() -> Bool {
        var returnValue = false

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: Constants.atcoderURL) { data, response, error in
            defer {
                dispatchGroup.leave()
            }
            guard
                let data = data,
                let document = try? HTMLDocument(data: data)
            else { return }

            if let _ = document.css("div.header-mypage_btn").first {
                returnValue = true
            }
        }.resume()
        dispatchGroup.wait()

        return returnValue
    }

    static func submit(problem: String, completion: @escaping (Result<Void, AtCoderSwiftCLIError>) -> Void) {
        if !loggedIn() {
            print("You are not logged in. Please login.", printer: .error)
        }
        let projectName = Path.current.lastComponent
        let taskScreenName = "\(projectName)_\(problem)"
        let submitURL = Constants.contestsURL.appendingPathComponent("\(projectName)/submit")
        let sourceFile = Path.current + Path("\(problem.uppercased())/main.swift")
        guard let sourceCode: String = try? sourceFile.read() else {
            completion(.failure(.init(message: "Can't read source code.")))
            return
        }

        URLSession.shared.dataTask(with: submitURL) { data, response, error in
            guard
                let data = data,
                let document = try? HTMLDocument(data: data)
            else {
                completion(.failure(.init(message: "Error at line \(#line)")))
                return
            }

            guard
                let option = document
                    .css("#select-lang-\(taskScreenName) select option")
                    .first(where: {$0.stringValue.lowercased().starts(with: "swift")}),
                let languageID = option.attr("value")
            else {
                print(document)
                completion(.failure(.init(message: "Error at line \(#line)")))
                return
            }
            let csrfToken = document.css("input[name=\"csrf_token\"]")
                .first?
                .attr("value")

            var urlComponents = URLComponents(
                url: submitURL, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = [
                .init(name: "data.TaskScreenName", value: taskScreenName),
                .init(name: "data.LanguageId", value: languageID),
                .init(name: "sourceCode", value: sourceCode),
                .init(name: "csrf_token", value: csrfToken),
            ]
            guard let url = urlComponents?.url else {
                completion(.failure(.init(message: "Error at line \(#line)")))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(.init(message: error.localizedDescription)))
                }
                completion(.success(()))
            }.resume()
        }.resume()
    }
}
