//
//  LoginViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
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
    @Published var isLoading: Bool = false
    @Published var showEmailError: Bool = false
    @Published var showPasswordError: Bool = false
    @Published var loginErrorMessage: String?
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
        showPasswordError = password.isEmpty
        return !showEmailError && !showPasswordError
    }

    func login() {
        guard validateFields() else { return }
        
        Task {
            isLoading = true
            do {
                let response = try await authService.login(email: email, password: password)
                SessionManager.shared.login(with: response.token)
            } catch let error as AuthError {
                loginErrorMessage = error.localizedDescription
                self.showError = true
            } catch {
                loginErrorMessage = "An unknown error occurred."
                self.showError = true
            }
            isLoading = false
        }
    }
    
    // MARK: - Private Methods
    private func updateEmailErrorState() {
        if showEmailError && !email.trimmingCharacters(in: .whitespaces).isEmpty {
            showEmailError = false
        }
    }
    
    private func updatePasswordErrorState() {
        if showPasswordError && !password.isEmpty {
            showPasswordError = false
        }
    }
}
