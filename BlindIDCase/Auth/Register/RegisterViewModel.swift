//
//  RegisterViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var email: String = "" {
        didSet {
            updateEmailErrorState()
        }
    }

    @Published var firstName: String = "" {
        didSet {
            updateNameErrorState()
        }
    }

    @Published var lastName: String = "" {
        didSet {
            updateSurnameErrorState()
        }
    }

    @Published var password: String = "" {
        didSet {
            updatePasswordErrorState()
        }
    }

    @Published var isLoading: Bool = false
    @Published var showEmailError: Bool = false
    @Published var showFirstNameError: Bool = false
    @Published var showLastNameError: Bool = false
    @Published var showPasswordError: Bool = false
    @Published var registerErrorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol

    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }

    // MARK: - Public Methods
    func validateFields() -> Bool {
        showEmailError = email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        showFirstNameError = firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        showLastNameError = lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        showPasswordError = password.count < 6

        return !showEmailError && !showFirstNameError && !showLastNameError && !showPasswordError
    }

    func register() {
        guard validateFields() else { return }
        Task {
            isLoading = true
            do {
                let response = try await authService.register(
                    email: email,
                    name: firstName,
                    surname: lastName,
                    password: password
                )
                SessionManager.shared.login(with: response.token)
            } catch let error as AuthError {
                registerErrorMessage = error.localizedDescription
                self.showError = true
            } catch {
                registerErrorMessage = "Bilinmeyen bir hata oluştu."
                self.showError = true
            }
            isLoading = false
        }
    }
    
    // MARK: - Private Methods
    private func updateEmailErrorState() {
        if showEmailError && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showEmailError = false
        }
    }
    
    private func updateNameErrorState() {
        if showFirstNameError && !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showFirstNameError = false
        }
    }
    
    private func updateSurnameErrorState() {
        if showLastNameError && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showLastNameError = false
        }
    }
    
    private func updatePasswordErrorState() {
        showPasswordError = password.count < 6
    }
}
