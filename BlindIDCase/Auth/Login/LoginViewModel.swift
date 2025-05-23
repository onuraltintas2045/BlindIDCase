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

    func login(completion: @escaping () -> Void) {
        guard validateFields() else { return }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            completion()
        }
    }
}
