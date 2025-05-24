//
//  UserService.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

protocol UserServiceProtocol {
    func getCurrentUser() async throws -> User
}

// TODO: - AuthService' de yaptığımız response handling buraya da uygulanacak, en son bütün Service yapıları ortaklanabilir mi diye bakılacak.
final class UserService: UserServiceProtocol {
    
    static let shared = UserService()
    private init() {}

    func getCurrentUser() async throws -> User {
        guard let token = KeychainManager.readToken(), !token.isEmpty else {
            throw UserServiceError.invalidToken
        }

        guard let url = URL(string: "https://moviatask.cerasus.app/api/auth/me") else {
            throw UserServiceError.unknown
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserServiceError.unknown
        }

        switch httpResponse.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(User.self, from: data)
            } catch {
                throw UserServiceError.decodingFailed
            }
        case 401:
            throw UserServiceError.invalidToken
        default:
            throw UserServiceError.unknown
        }
    }
}
