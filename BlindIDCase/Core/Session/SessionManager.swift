//
//  SessionManager.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    @Published var authState: AuthState = .fetchingCurrentUser

    private init() {
        validateSession()
    }

    func validateSession() {
        guard let token = KeychainManager.readToken(), !token.isEmpty else {
            self.authState = .loggedOut
            return
        }
        
        self.authState = .fetchingCurrentUser
        
        UserDataManager.shared.fetchCurrentUser { success in

            success ? (self.authState = .loggedIn) : self.logout()
            
        }
    }

    func logout() {
        KeychainManager.clear()
        UserDataManager.shared.clearUser()
        self.authState = .loggedOut
    }
    
    func login(with token: String) {
        KeychainManager.save(token: token)
        
        self.authState = .fetchingCurrentUser

        UserDataManager.shared.fetchCurrentUser { success in
            success ? (self.authState = .loggedIn) : self.logout()
        }
    }
}
