//
//  AuthService.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, name: String, surname: String, password: String) async throws -> AuthResponse
}

// TODO: - Bütün yapılar oluşturulduktan sonra service yapıları ortaklanabilir mi diye kontrol edilecek.
final class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    
    private init() {}
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let endpoint = "https://moviatask.cerasus.app/api/auth/login"
        let body = LoginRequest(email: email, password: password)
        return try await sendRequest(to: endpoint, method: "POST", body: body, expectedStatus: 200, requestType: .login)
    }
    
    func register(email: String, name: String, surname: String, password: String) async throws -> AuthResponse {
        let endpoint = "https://moviatask.cerasus.app/api/auth/register"
        let body = RegisterRequest(name: name, surname: surname, email: email, password: password)
        return try await sendRequest(to: endpoint, method: "POST", body: body, expectedStatus: 201, requestType: .register)
    }
    
    private func sendRequest<T: Encodable>(
        to urlString: String,
        method: String,
        body: T,
        expectedStatus: Int,
        requestType: RequestType
    ) async throws -> AuthResponse {
        guard let url = URL(string: urlString) else {
            throw AuthError.unknown
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw AuthError.unknown
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.unknown
        }
        
        switch httpResponse.statusCode {
            case expectedStatus:
                do {
                    return try JSONDecoder().decode(AuthResponse.self, from: data)
                } catch {
                    throw AuthError.unknown
                }
            case 400:
                if requestType == .login {
                    throw AuthError.invalidCredentials
                } else if requestType == .register {
                    throw AuthError.userAlreadyExists
                } else {
                    throw AuthError.unknown
                }
            default:
                throw AuthError.unknown
                
        }
    }
}
