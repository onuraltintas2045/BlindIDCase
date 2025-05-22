//
//  SessionManager.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var isLoggedIn: Bool = false

    private init() {
        checkLoginStatus()
    }

    func checkLoginStatus() {
        if let token = KeychainManager.readToken(), !token.isEmpty {
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }

    func logout() {
        KeychainManager.clear()
        isLoggedIn = false
    }
    
    func login(with token: String) {
        KeychainManager.save(token: token)
        self.isLoggedIn = true
    }
}
