//
//  APIService.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/2/25.
//

import Foundation

// Base URL for the API
struct API {
    static var baseURL: String {
        Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String ?? "http://localhost:3000"
    }
}

// Represents the login response containing a JWT token
struct LoginResponse: Codable {
    let token: String
}

// Enum representing all possible API endpoints
enum APIEndpoint {
    case items
    case item(id: Int)
    case comments(itemId: Int)
    case users
    case user(id: Int)

    // Endpoint paths
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

    // Response types
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

// Handles all network interactions and caching logic.
class APIService {
    
    // Singleton so that APIService can be accessed anywhere in the app
    static let shared = APIService()
    private init() {}

    // Internal init for testing purposes
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    var urlSession: URLSession = .shared

    // Logs in the user and returns a JWT token
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["username": username, "password": password])

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data, let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                return completion(.failure(NSError(domain: "Decode error", code: -1)))
            }
            completion(.success(decoded.token))
        }.resume()
    }

    // Fetches data from a given endpoint, uses cache if available
    func fetch<T: Codable>(_ endpoint: APIEndpoint, token: String, completion: @escaping (Result<T, Error>) -> Void) {
        // Attempt to load from cache first
        if let cached: T = loadCache(for: endpoint, as: T.self) {
            completion(.success(cached))
        }

        // Proceed with network request
        guard let url = URL(string: "\(API.baseURL)\(endpoint.path)") else {
            return completion(.failure(NSError(domain: "Invalid URL", code: 0)))
        }

        // Adds required token
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
                self.cache(decoded, for: endpoint) // Save to cache on success
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Saves response data to a local cache
    func cache<T: Encodable>(_ data: T, for endpoint: APIEndpoint) {
        let url = cacheURL(for: endpoint)
        if let encoded = try? JSONEncoder().encode(data) {
            try? encoded.write(to: url)
        }
    }

    // Loads response data from local cache
    func loadCache<T: Decodable>(for endpoint: APIEndpoint, as type: T.Type) -> T? {
        let url = cacheURL(for: endpoint)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    // Generates the local cache file URL for an endpoint
    func cacheURL(for endpoint: APIEndpoint) -> URL {
        let fileName = "cache_\(endpoint.path.replacingOccurrences(of: "/", with: "_"))"
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }
}
