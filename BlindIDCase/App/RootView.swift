//
//  ContentView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var session: SessionManager
    var body: some View {
        switch session.authState {
            case .fetchingCurrentUser:
                LoadingOverlayView()
            case .loggedIn:
                MainTabView()
            case .loggedOut:
                LoginView()
        }
    }
}
