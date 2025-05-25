//
//  ProfileViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var name: String = "" {
        didSet {
            if showNameError && !name.trimmingCharacters(in: .whitespaces).isEmpty {
                showNameError = false
            }
        }
    }
    @Published var surname: String = "" {
        didSet {
            if showSurnameError && !surname.trimmingCharacters(in: .whitespaces).isEmpty {
                showSurnameError = false
            }
        }
    }
    @Published var email: String = "" {
        didSet {
            if showEmailError && !email.trimmingCharacters(in: .whitespaces).isEmpty {
                showEmailError = false
            }
        }
    }
    @Published var password: String = "" {
        didSet {
            password.count < 6 ? (showPasswordError = true) : (showPasswordError = false)
        }
    }

    @Published var isEditing: Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var showNameError: Bool = false
    @Published var showSurnameError: Bool = false
    @Published var showEmailError: Bool = false
    @Published var showPasswordError: Bool = false


    init() {
        loadCurrentUser()
    }

    func loadCurrentUser() {
        guard let currentUser = UserDataManager.shared.currentUser else { return }
        self.name = currentUser.name
        self.surname = currentUser.surname
        self.email = currentUser.email
    }
    
    func updateCurrentUser(authUser: AuthUser) {
        UserDataManager.shared.updateCurrentUser(name: authUser.name, surname: authUser.surname, email: authUser.email)
        loadCurrentUser()
    }

    func validateFields() -> Bool {
        showNameError = name.trimmingCharacters(in: .whitespaces).isEmpty
        showSurnameError = surname.trimmingCharacters(in: .whitespaces).isEmpty
        showEmailError = email.trimmingCharacters(in: .whitespaces).isEmpty
        showPasswordError = password.count < 6
        return !showNameError && !showSurnameError && !showEmailError && !showPasswordError
    }
    
    func saveChanges() async {
        
        guard validateFields() else { return }
        isLoading = true
        errorMessage = nil

        let request = UpdateUserProfileRequest(
            name: name, surname: surname, email: email, password: password
        )

        do {
            let updatedUser = try await UserService.shared.updateUserProfile(request)
            self.updateCurrentUser(authUser: updatedUser)
            isEditing = false
        } catch {
            errorMessage = "Profil güncellenemedi. Lütfen tekrar deneyin."
        }

        isLoading = false
    }
}
