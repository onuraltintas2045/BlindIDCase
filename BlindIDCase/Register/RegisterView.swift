//
//  RegisterView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct RegisterView: View {
    @Binding var showLogin: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Kayıt Ol")
                .font(.title)
                .bold()

            Text("Buraya kayıt alanları eklenecek...")

            Button("Kayıt Olmayı Tamamla") {
                showLogin = false
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .padding()
    }
}
