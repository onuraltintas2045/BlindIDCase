//
//  RegisterViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation

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

    func validateFields() -> Bool {
        showEmailError = email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        showFirstNameError = firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        showLastNameError = lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        showPasswordError = password.count < 6

        return !showEmailError && !showFirstNameError && !showLastNameError && !showPasswordError
    }

    func register() {
        guard validateFields() else { return }
        
        isLoading = true
        
        AuthService.shared.register(email: email, name: firstName, surname: lastName, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                    case .success(let response):
                        SessionManager.shared.login(with: response.token)
                    case .failure(let error):
                        // TODO: - Hata Mesajı Gösteren Genel Bir Yapı Eklenecek
                        print(error.errorDescription ?? "Bilinmeyen bir hata oluştu")
                }
            }
        }
    }
}
