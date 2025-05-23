//
//  LoginViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 23.05.2025.
//

import Foundation
import Combine

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
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var showEmailError: Bool = false
    @Published var showPasswordError: Bool = false

    func validateFields() -> Bool {
        showEmailError = email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        showPasswordError = password.isEmpty
        return !showEmailError && !showPasswordError
    }

    func login() {
        guard validateFields() else { return }
        
        isLoading = true
        
        AuthService.shared.login(email: email, password: password) { [weak self] result in
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
