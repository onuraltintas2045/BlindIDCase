//
//  LoginView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI
import Combine

// TODO: - Klavye yüksekliğine göre layout güncellemesi yapılmalı
struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @State var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 60)
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
                
                Spacer().frame(height: 40)
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .padding()
                    .frame(height: 45)
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
                    .frame(height: 45)
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
                
                Button {
                    viewModel.login()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.blue)
                .frame(height: 35)
                .cornerRadius(8)
                
                Spacer()

                VStack(spacing: 0) {
                    NavigationLink(destination: RegisterView()) {
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
            .padding()
            .allowsHitTesting(!viewModel.isLoading)
            .background(viewModel.isLoading ? Color.black.opacity(0.3) : Color.white)
            
        }
    }
}
