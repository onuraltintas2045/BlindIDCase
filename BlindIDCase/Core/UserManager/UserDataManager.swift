//
//  UserDataManager.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import Foundation

@MainActor
final class UserDataManager: ObservableObject {

    static let shared = UserDataManager()

    @Published var currentUser: User?

    private let userService: UserServiceProtocol

    private init(userService: UserServiceProtocol = UserService.shared) {
        self.userService = userService
    }

    func fetchCurrentUser() async -> Bool {
        do {
            let user = try await userService.getCurrentUser()
            self.currentUser = user
            return true
        } catch {
            return false
        }
    }

    func clearUser() {
        self.currentUser = nil
    }
}
