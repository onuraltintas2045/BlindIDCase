//
//  SessionManager.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

@MainActor
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
        
        Task {
            await updateAuthStateAfterUserFetch()
        }
    }

    func logout() {
        KeychainManager.clear()
        UserDataManager.shared.clearUser()
        self.authState = .loggedOut
    }
    
    func login(with token: String) {
        KeychainManager.save(token: token)
        Task {
            await updateAuthStateAfterUserFetch()
        }
    }
    
    private func updateAuthStateAfterUserFetch() async {
        self.authState = .fetchingCurrentUser
        let success = await UserDataManager.shared.fetchCurrentUser()
        self.authState = success ? .loggedIn : .loggedOut
    }
}
