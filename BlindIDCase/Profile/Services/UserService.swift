//
//  UserService.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

enum UserServiceError: Error {
    case invalidToken
    case requestFailed(Error)
    case decodingFailed
    case unknown
}

final class UserService {
    static func getCurrentUser(completion: @escaping (Result<User, UserServiceError>) -> Void) {
        guard let token = KeychainManager.readToken(), !token.isEmpty else {
            completion(.failure(.invalidToken))
            return
        }

        guard let url = URL(string: "https://moviatask.cerasus.app/api/auth/me") else {
            completion(.failure(.unknown))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        completion(.failure(.unknown))
                        return
                    }

                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        completion(.success(user))
                    } catch {
                        completion(.failure(.decodingFailed))
                    }

                } else if httpResponse.statusCode == 401 {
                    completion(.failure(.invalidToken))
                } else {
                    completion(.failure(.unknown))
                }
            } else {
                completion(.failure(.unknown))
            }
        }.resume()
    }
}
