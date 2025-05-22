//
//  BlindIDCaseApp.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

@main
struct BlindIDCaseApp: App {
    @StateObject private var session = SessionManager.shared
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
        }
    }
}
