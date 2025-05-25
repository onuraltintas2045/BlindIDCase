//
//  MovieCardView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI
import Kingfisher

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // TODO: - Image için KingFisher eklenecek
            KFImage(URL(string: movie.posterUrl))
                .resizable()
                .cancelOnDisappear(true)
                .cacheOriginalImage()
                .placeholder {
                    Color.gray.opacity(0.3)
                }
                .onFailure { _ in
                    print("hata")
                }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
                .clipped()

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Text("Year: \(String(movie.year))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("⭐️ \(String(format: "%.1f", movie.rating))")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
