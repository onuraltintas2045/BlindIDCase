//
//  FavoritesView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.favoriteMovies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieCardView(movie: movie)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top)
            }
            .padding(.bottom)
            .background(Color.black.opacity(0.1))
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.refreshIsLikedStatesFromUser()
            }
        }
    }
}
