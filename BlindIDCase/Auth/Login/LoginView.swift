//
//  LoginView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = LoginViewModel()
    @State var isPasswordVisible: Bool = false
    @EnvironmentObject private var keyboard: KeyboardResponder
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: keyboard.isKeyboardVisible ? 0 : 30)
                
                // MARK: - Logo
                if !keyboard.isKeyboardVisible {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 120, maxHeight: 120)
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
                
                if viewModel.showEmailError || viewModel.showPasswordError  {
                    Text("Please fill out all fields.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)
                }
                
                // MARK: - Login Button
                Button {
                    viewModel.login()
                } label: {
                    Text("Log In")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                }
                .background(Color.blue)
                .frame(maxHeight: 35)
                .cornerRadius(8)
                
                Spacer()

                // MARK: - Navigation Link
                VStack(spacing: 0) {
                    NavigationLink(destination: RegisterView().environmentObject(keyboard)) {
                        Text("Create an Account")
                            .foregroundColor(.blue)
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .frame(height: 35)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1))
                    
                    Image("LaunchImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 40)
                        .clipped()
                }
                
            }
            .frame(maxHeight: keyboard.isKeyboardVisible ? (UIScreen.main.bounds.height - keyboard.keyboardHeight) : .infinity)
            .padding()
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
            
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Login Failed"),
                message: Text(viewModel.loginErrorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
