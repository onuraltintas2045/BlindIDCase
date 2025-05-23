//
//  RegisterView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI
// TODO: - Klavyenin açılmasına göre layout güncellenecek.
struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 20)
            
            Image("LaunchImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 60)
                .clipped()
            
            Spacer().frame(height: 20)

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding()
                .frame(height: 45)
                .background(RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.showEmailError ? Color.red : Color.gray, lineWidth: 1))

            TextField("Name", text: $viewModel.firstName)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding()
                .frame(height: 45)
                .background(RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.showFirstNameError ? Color.red : Color.gray, lineWidth: 1))

            TextField("Surname", text: $viewModel.lastName)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding()
                .frame(height: 45)
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

            Button {
                viewModel.register()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color.blue)
            .frame(height: 45)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
        .allowsHitTesting(!viewModel.isLoading)
        .background(viewModel.isLoading ? Color.black.opacity(0.3) : Color.white)
    }
}
