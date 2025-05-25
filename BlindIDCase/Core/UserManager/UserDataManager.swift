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
    
    func updateCurrentUser(name: String, surname: String, email: String) {
        guard currentUser != nil else { return }
        currentUser?.name = name
        currentUser?.surname = surname
        currentUser?.email = email
    }
    
    func updateLikedMovies(likedMovies: [Int]) {
        guard currentUser != nil else { return }
        currentUser?.likedMovies = likedMovies
    }

    func clearUser() {
        self.currentUser = nil
    }
}
