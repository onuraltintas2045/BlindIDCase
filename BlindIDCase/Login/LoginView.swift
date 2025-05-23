//
//  LoginView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var tokenInput: String = ""
    @ObservedObject private var session = SessionManager.shared
    @State private var showRegister = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login View")
                    .font(.title)
                    .bold()

                TextField("Token girin", text: $tokenInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Giriş Yap") {
                    login()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal)

                Button("Kayıt Ol") {
                    showRegister = true
                }
                .padding(.top)

                NavigationLink(destination: RegisterView(showLogin: $showRegister),
                               isActive: $showRegister) {
                    EmptyView()
                }
            }
            .padding()
        }
    }

    private func login() {
        guard !tokenInput.isEmpty else { return }
        session.login(with: tokenInput)
    }
}

#Preview {
    LoginView()
}
