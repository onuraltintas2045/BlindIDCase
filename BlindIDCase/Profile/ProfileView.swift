//
//  ProfileView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 30)

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .foregroundColor(.blue)

                    formField(title: "Name", text: $viewModel.name, showError: viewModel.showNameError, isEditing: viewModel.isEditing, icon: "person.fill")
                    formField(title: "Surname", text: $viewModel.surname, showError: viewModel.showSurnameError, isEditing: viewModel.isEditing, icon: "person.text.rectangle")
                    formField(title: "Email", text: $viewModel.email, showError: viewModel.showEmailError, isEditing: viewModel.isEditing, icon: "envelope.fill")

                    if viewModel.isEditing {
                        formField(
                            title: "New Password",
                            text: $viewModel.password,
                            showError: viewModel.showPasswordError,
                            isEditing: viewModel.isEditing,
                            icon: "lock.fill",
                            isSecure: true,
                            isPasswordVisible: $viewModel.isPasswordVisible
                        )
                    }

                    if viewModel.showPasswordError {
                        Text("Password must be at least 6 characters long.")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)
                    }

                    if viewModel.showNameError || viewModel.showSurnameError || viewModel.showEmailError {
                        Text("Please fill out all fields.")
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)
                    }

                    Button {
                        if viewModel.isEditing {
                            viewModel.updateProfile()
                        } else {
                            viewModel.isEditing = true
                        }
                    } label: {
                        Text(viewModel.isEditing ? "Save" : "Edit")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                    }
                    .background(viewModel.isEditing ? Color.green : Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Spacer()
                    
                    Button {
                        SessionManager.shared.logout()
                    } label: {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding()
                }
                .padding(.vertical)
            }

            if viewModel.isLoading {
                LoadingOverlayView()
            }
        }
        .allowsHitTesting(!viewModel.isLoading)
        .onDisappear {
            viewModel.isEditing = false
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "An unexpected error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    @ViewBuilder
    private func formField(
        title: String,
        text: Binding<String>,
        showError: Bool,
        isEditing: Bool,
        icon: String,
        isSecure: Bool = false,
        isPasswordVisible: Binding<Bool>? = nil
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)

            if isEditing {
                ZStack(alignment: .trailing) {
                    Group {
                        if isSecure, let isVisible = isPasswordVisible {
                            if isVisible.wrappedValue {
                                TextField(title, text: text)
                            } else {
                                SecureField(title, text: text)
                            }
                        } else {
                            TextField(title, text: text)
                        }
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.trailing, isSecure ? 28 : 0)

                    if isSecure, let isVisible = isPasswordVisible {
                        Button {
                            isVisible.wrappedValue.toggle()
                        } label: {
                            Image(systemName: isVisible.wrappedValue ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 4)
                    }
                }
            } else {
                Text(text.wrappedValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8)
            .stroke(showError ? Color.red : Color.gray, lineWidth: 1))
        .padding(.horizontal)
    }
}
