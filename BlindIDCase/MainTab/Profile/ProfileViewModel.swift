//
//  ProfileViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var name: String = "" {
        didSet {
            updateNameErrorState()
        }
    }
    @Published var surname: String = "" {
        didSet {
            updateSurnameErrorState()
        }
    }
    @Published var email: String = "" {
        didSet {
            updateEmailErrorState()
        }
    }
    @Published var password: String = "" {
        didSet {
            updatePasswordErrorState()
        }
    }

    @Published var isEditing: Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    @Published var showNameError: Bool = false
    @Published var showSurnameError: Bool = false
    @Published var showEmailError: Bool = false
    @Published var showPasswordError: Bool = false

    // MARK: - Init
    init() {
        loadCurrentUser()
    }

    // MARK: - Public Methods
    func updateProfile() {
        guard validateFields() else { return }

        Task {
            await saveChanges()
        }
    }

    // MARK: - Private Methods
    private func saveChanges() async {
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
            errorMessage = "Profile could not be updated. Please try again."
            showError = true
        }

        isLoading = false
    }

    private func loadCurrentUser() {
        guard let currentUser = UserDataManager.shared.currentUser else { return }
        self.name = currentUser.name
        self.surname = currentUser.surname
        self.email = currentUser.email
    }

    private func updateCurrentUser(authUser: AuthUser) {
        UserDataManager.shared.updateCurrentUser(name: authUser.name, surname: authUser.surname, email: authUser.email)
        loadCurrentUser()
    }

    private func validateFields() -> Bool {
        showNameError = name.trimmingCharacters(in: .whitespaces).isEmpty
        showSurnameError = surname.trimmingCharacters(in: .whitespaces).isEmpty
        showEmailError = email.trimmingCharacters(in: .whitespaces).isEmpty
        showPasswordError = password.count < 6
        return !showNameError && !showSurnameError && !showEmailError && !showPasswordError
    }
    
    private func updateEmailErrorState() {
        if showEmailError && !email.trimmingCharacters(in: .whitespaces).isEmpty {
            showEmailError = false
        }
    }
    
    private func updateNameErrorState() {
        if showNameError && !name.trimmingCharacters(in: .whitespaces).isEmpty {
            showNameError = false
        }
    }
    
    private func updateSurnameErrorState() {
        if showSurnameError && !surname.trimmingCharacters(in: .whitespaces).isEmpty {
            showSurnameError = false
        }
    }
    
    private func updatePasswordErrorState() {
        showPasswordError = password.count < 6
    }
}
