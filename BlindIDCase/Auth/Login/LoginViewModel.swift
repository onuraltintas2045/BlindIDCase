//
//  LoginViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            if showEmailError && !email.trimmingCharacters(in: .whitespaces).isEmpty {
                showEmailError = false
            }
        }
    }
    
    @Published var password: String = "" {
        didSet {
            if showPasswordError && !password.isEmpty {
                showPasswordError = false
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var showEmailError: Bool = false
    @Published var showPasswordError: Bool = false
    @Published var loginErrorMessage: String?
    
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }

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
            } catch {
                loginErrorMessage = "Bilinmeyen bir hata oluştu."
            }
            isLoading = false
        }
    }
}
