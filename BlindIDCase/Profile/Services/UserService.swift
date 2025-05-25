//
//  UserService.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

protocol UserServiceProtocol {
    func getCurrentUser() async throws -> User
    func updateUserProfile(_ request: UpdateUserProfileRequest) async throws -> AuthUser
}

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

    func updateUserProfile(_ requestBody: UpdateUserProfileRequest) async throws -> AuthUser {
        guard let token = KeychainManager.readToken(), !token.isEmpty else {
            throw UserServiceError.invalidToken
        }

        guard let url = URL(string: "https://moviatask.cerasus.app/api/users/profile") else {
            throw UserServiceError.unknown
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserServiceError.unknown
        }

        switch httpResponse.statusCode {
        case 200:
            do {
                let decodedResponse = try JSONDecoder().decode(UpdateUserProfileResponse.self, from: data)
                return decodedResponse.user
            } catch {
                throw UserServiceError.decodingFailed
            }
        default:
            throw UserServiceError.unknown
        }
    }
}
