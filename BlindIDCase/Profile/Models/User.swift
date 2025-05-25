//
//  User.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

struct User: Codable {
    let id: String
    var name: String
    var surname: String
    var email: String
    var likedMovies: [Int]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case surname
        case email
        case likedMovies
        case createdAt
        case updatedAt
    }
}

enum UserServiceError: Error {
    case invalidToken
    case requestFailed(Error)
    case decodingFailed
    case unknown
}

struct UpdateUserProfileRequest: Codable {
    let name: String
    let surname: String
    let email: String
    let password: String
}

struct UpdateUserProfileResponse: Codable {
    let message: String
    let user: AuthUser
}
