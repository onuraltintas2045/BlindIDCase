//
//  RegisterViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            if showEmailError && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                showEmailError = false
            }
        }
    }

    @Published var firstName: String = "" {
        didSet {
            if showFirstNameError && !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                showFirstNameError = false
            }
        }
    }

    @Published var lastName: String = "" {
        didSet {
            if showLastNameError && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                showLastNameError = false
            }
        }
    }

    @Published var password: String = "" {
        didSet {
            showPasswordError = password.count < 6
        }
    }

    @Published var isLoading: Bool = false
    @Published var showEmailError: Bool = false
    @Published var showFirstNameError: Bool = false
    @Published var showLastNameError: Bool = false
    @Published var showPasswordError: Bool = false
    @Published var registerErrorMessage: String?

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }

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
            } catch {
                registerErrorMessage = "Bilinmeyen bir hata oluştu."
            }
            isLoading = false
        }
    }
}
