//
//  RegisterView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI
struct RegisterView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = RegisterViewModel()
    @State private var isPasswordVisible: Bool = false
    @EnvironmentObject var keyboard: KeyboardResponder

    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                Spacer().frame(maxHeight: keyboard.isKeyboardVisible ? 0 : 20)
                
                // MARK: - Logo
                if !keyboard.isKeyboardVisible {
                    Image("LaunchImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 120, maxHeight: 60)
                        .clipped()
                }
                
                
                // MARK: - Form Fields
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .padding()
                    .frame(maxHeight: 45)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.showEmailError ? Color.red : Color.gray, lineWidth: 1))

                TextField("Name", text: $viewModel.firstName)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .padding()
                    .frame(maxHeight: 45)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.showFirstNameError ? Color.red : Color.gray, lineWidth: 1))

                TextField("Surname", text: $viewModel.lastName)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .padding()
                    .frame(maxHeight: 45)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.showLastNameError ? Color.red : Color.gray, lineWidth: 1))
                

                ZStack(alignment: .trailing) {
                    Group {
                        if isPasswordVisible {
                            TextField("Password", text: $viewModel.password)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                        }
                    }
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .padding(.trailing, 40)
                    .padding()
                    .frame(maxHeight: 45)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.showPasswordError ? Color.red : Color.gray, lineWidth: 1))
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
                
                if viewModel.showPasswordError {
                    Text("Password must be at least 6 characters long.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)
                }
                
                if viewModel.showEmailError || viewModel.showFirstNameError || viewModel.showLastNameError  {
                    Text("Please fill out all fields.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)
                }

                // MARK: - Login Button
                Button {
                    viewModel.register()
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                }
                .background(Color.blue)
                .frame(maxHeight: 45)
                .cornerRadius(8)

                Spacer()
            }
            .padding()
        }
        
        .frame(maxHeight: keyboard.isKeyboardVisible ? (UIScreen.main.bounds.height - keyboard.keyboardHeight) : .infinity)
        .allowsHitTesting(!viewModel.isLoading)
        .background(
            Group {
                if viewModel.isLoading {
                    LoadingOverlayView()
                } else {
                    Color.white
                }
            }
        )
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Registration Failed"),
                message: Text(viewModel.registerErrorMessage ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
