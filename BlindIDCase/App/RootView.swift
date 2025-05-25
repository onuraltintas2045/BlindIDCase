//
//  ContentView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject private var keyboardResponder = KeyboardResponder.shared
    var body: some View {
        switch session.authState {
            case .fetchingCurrentUser:
                LoadingOverlayView()
            case .loggedIn:
                MainTabView()
                    .environmentObject(keyboardResponder)
            case .loggedOut:
                LoginView()
                    .environmentObject(keyboardResponder)
        }
    }
}
