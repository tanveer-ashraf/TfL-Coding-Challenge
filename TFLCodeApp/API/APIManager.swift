//
//  APIManager.swift
//  TFLCodeApp
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import Foundation

enum APIError: Error {
    case networkError
    case parsingError
}

protocol APIManaging {
    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void)
}

final class APIManager: APIManaging {
    static let shared = APIManager()

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) {
        urlSession.dataTask(with: urlRequest(for: request)) { responseData, _, _ in
            if let data = responseData {
                do {
                    let response = try JSONDecoder().decode(Value.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.parsingError))
                }
            } else {
                completion(.failure(.networkError))
            }
        }.resume()
    }

    private func urlRequest<Value>(for request: Request<Value>) -> URLRequest {
        let url = URL(string: request.path)!
        var result = URLRequest(url: url)
        result.httpMethod = request.method.rawValue
        return result
    }
}
