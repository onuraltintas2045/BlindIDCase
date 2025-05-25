//
//  EmptyView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 25.05.2025.
//

import SwiftUI

struct EmptyStateView: View {
    var title: String
    var message: String
    var systemImageName: String = "tray"

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray.opacity(0.6))

            Text(title)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
