//
//  LoginModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: User
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case serverError(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "E-posta veya şifre hatalı."
        case .serverError(let message):
            return message
        case .unknown:
            return "Bilinmeyen bir hata oluştu."
        }
    }
}
