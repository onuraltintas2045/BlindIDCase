//
//  MovieDetailView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    let movie: Movie
    @State private var isFavorite: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    KFImage(URL(string: movie.posterUrl))
                        .resizable()
                        .cancelOnDisappear(true)
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 450)
                                .foregroundColor(.clear)
                        }
                        .frame(width: 300, height: 450)
                        .scaledToFit()
                        .cornerRadius(12)
                        .shadow(radius: 6)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("📅 \(String(movie.year))")
                        Text("🎭 \(movie.category)")
                        Text("⭐️ \(String(format: "%.1f", movie.rating))")
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                .padding(.horizontal)

                Divider()
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    Text(movie.description)
                        .font(.body)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Actors")
                        .font(.headline)
                    ForEach(movie.actors, id: \.self) { actor in
                        Text("• \(actor)")
                            .font(.body)
                    }
                }
                .padding(.horizontal)

                Button(action: {
                    isFavorite.toggle()
                }) {
                    HStack {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .primary)
                        Text(isFavorite ? "Unfavorite" : "Add Favorite")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .padding(.vertical)
            .background(Color.black.opacity(0.1))
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
