//
//  SessionManager.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    @Published var authState: AuthState = .checkingToken
    @Published var currentUser: User?

    private init() {
        validateSession()
    }

    func validateSession() {
        guard let token = KeychainManager.readToken(), !token.isEmpty else {
            self.authState = .loggedOut
            return
        }
        
        UserService.shared.getCurrentUser { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.currentUser = user
                        self.authState = .loggedIn
                    case .failure:
                        self.authState = .loggedOut
                }
            }
        }
    }

    func logout() {
        KeychainManager.clear()
        self.authState = .loggedOut
    }
    
    func login(with token: String) {
        KeychainManager.save(token: token)
        self.authState = .loggedIn
    }
}
