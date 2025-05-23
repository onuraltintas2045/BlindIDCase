//
//  AuthService.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

// TODO: - Bütün yapılar oluşturulduktan sonra service yapıları ortaklanabilir mi diye kontrol edilecek.
final class AuthService {
    
    static let shared = AuthService()
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, AuthError>) -> Void) {
        
        guard let url = URL(string: "https://moviatask.cerasus.app/api/auth/login") else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(email: email, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = data else {
                        completion(.failure(.unknown))
                        return
                    }
                    
                    do {
                        let user = try JSONDecoder().decode(AuthResponse.self, from: data)
                        completion(.success(user))
                    } catch {
                        completion(.failure(.unknown))
                    }
                case 400:
                    completion(.failure(.invalidCredentials))
                default:
                    completion(.failure(.unknown))
                    
            }
        }.resume()
    }
    
    func register(email: String, name: String, surname: String, password: String, completion: @escaping (Result<AuthResponse, AuthError>) -> Void) {
        
        guard let url = URL(string: "https://moviatask.cerasus.app/api/auth/register") else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = RegisterRequest(name: name, surname: surname, email: email, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            switch httpResponse.statusCode {
                case 201:
                    guard let data = data else {
                        completion(.failure(.unknown))
                        return
                    }
                    
                    do {
                        let user = try JSONDecoder().decode(AuthResponse.self, from: data)
                        completion(.success(user))
                    } catch {
                        completion(.failure(.unknown))
                    }
                case 400:
                    completion(.failure(.userAlreadyExists))
                default:
                    completion(.failure(.unknown))
                    
            }
        }.resume()
    }
}
