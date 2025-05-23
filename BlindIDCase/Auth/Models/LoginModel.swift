//
//  LoginModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

struct LoginUser: Codable {
    let id: String
    let name: String
    let surname: String
    let email: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: LoginUser
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case requestError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "E-posta veya şifre hatalı."
        case .requestError:
            return "Bir hata oluştu. Lütfen tekrar deneyin."
        case .unknown:
            return "Bilinmeyen bir hata oluştu."
        }
    }
}
