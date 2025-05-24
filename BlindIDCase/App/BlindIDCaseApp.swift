//
//  BlindIDCaseApp.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 22.05.2025.
//

import SwiftUI

@main
struct BlindIDCaseApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(SessionManager.shared)
        }
    }
}
