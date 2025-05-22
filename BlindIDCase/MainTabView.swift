//
//  MainTabView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject private var session = SessionManager.shared
    var body: some View {
        VStack(spacing: 20) {
            Text("MainTabView")
                .font(.title)
                .bold()

            Button(action: {
                logout()
            }) {
                Text("Çıkış Yap")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .padding()
    }

    private func logout() {
        session.logout()
    }
}

#Preview {
    MainTabView()
}
