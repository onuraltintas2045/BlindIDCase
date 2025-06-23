//
//  ProfileView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var keyboard: KeyboardResponder
    @State private var isPressed = false
    @State private var buttonName: ClickedButton = .none
    @State private var navigateToRegister = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(maxHeight: keyboard.isKeyboardVisible ? 0 : 20)
                    
                    if !keyboard.isKeyboardVisible {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .foregroundColor(.blue)
                    }
                    
                    formField(title: "Name", text: $viewModel.name, showError: viewModel.showNameError, isEditing: viewModel.isEditing, icon: "person.fill").frame(maxHeight: 35)
                    formField(title: "Surname", text: $viewModel.surname, showError: viewModel.showSurnameError, isEditing: viewModel.isEditing, icon: "person.text.rectangle").frame(maxHeight: 35)
                    formField(title: "Email", text: $viewModel.email, showError: viewModel.showEmailError, isEditing: viewModel.isEditing, icon: "envelope.fill").frame(maxHeight: 35)

                    if viewModel.isEditing {
                        formField(
                            title: "New Password",
                            text: $viewModel.password,
                            showError: viewModel.showPasswordError,
                            isEditing: viewModel.isEditing,
                            icon: "lock.fill",
                            isSecure: true,
                            isPasswordVisible: $viewModel.isPasswordVisible
                        ).frame(maxHeight: 35)
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
                            withAnimation(.easeIn(duration: 0.1)) {
                                buttonName = .editProfile
                                isPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isPressed = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    viewModel.updateProfile()
                                }
                            }
                        } else {
                            withAnimation(.easeIn(duration: 0.1)) {
                                buttonName = .editProfile
                                isPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isPressed = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    viewModel.isEditing = true
                                }
                            }
                        }
                    } label: {
                        Text(viewModel.isEditing ? "Save" : "Edit")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 35)
                            .padding()
                        
                    }
                    .background(viewModel.isEditing ? Color.green : Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .scaleEffect((isPressed && buttonName == .editProfile) ? 0.8 : 1.0)
                    
                    Button {
                        withAnimation(.easeIn(duration: 0.1)) {
                            buttonName = .logOut
                            isPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeOut(duration: 0.1)) {
                                isPressed = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                SessionManager.shared.logout()
                            }
                        }
                    } label: {
                        Text("Log Out")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, maxHeight: 35)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .scaleEffect((isPressed && buttonName == .logOut) ? 0.8 : 1.0)

                }
            }

            if viewModel.isLoading {
                LoadingOverlayView()
            }
        }
        .frame(maxHeight: keyboard.isKeyboardVisible ? (UIScreen.main.bounds.height - keyboard.keyboardHeight) : .infinity)
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
