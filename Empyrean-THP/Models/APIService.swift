//
//  APIService.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/2/25.
//

import Foundation

struct API {
    static let baseURL = "http://192.168.1.230:3000"
}

struct LoginResponse: Codable {
    let token: String
}

enum APIEndpoint {
    case items
    case item(id: Int)
    case comments(itemId: Int)
    case users
    case user(id: Int)

    var path: String {
        switch self {
        case .items:
            return "/items"
        case .item(let id):
            return "/items/\(id)"
        case .comments(let itemId):
            return "/items/\(itemId)/comments"
        case .users:
            return "/users"
        case .user(let id):
            return "/users/\(id)"
        }
    }

    var responseType: Decodable.Type {
        switch self {
        case .items: return [Item].self
        case .item: return Item.self
        case .comments: return [Comment].self
        case .users: return [User].self
        case .user: return User.self
        }
    }
}

class APIService {
    static let shared = APIService()
    private init() {}

    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["username": username, "password": password])

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { return completion(.failure(error)) }
            guard let data = data,
                  let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                return completion(.failure(NSError(domain: "Decode error", code: -1)))
            }
            completion(.success(decoded.token))
        }.resume()
    }
    
    func fetch<T: Decodable>(_ endpoint: APIEndpoint, token: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)\(endpoint.path)") else {
            return completion(.failure(NSError(domain: "Invalid URL", code: 0)))
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(NSError(domain: "No data", code: 0)))
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
