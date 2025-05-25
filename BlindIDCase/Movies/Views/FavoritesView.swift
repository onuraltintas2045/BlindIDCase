//
//  FavoritesView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: HomeViewModel

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Movie List, EmptyView
                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.favoriteMovies.isEmpty {
                            EmptyStateView(
                                title: "No Favorites",
                                message: "You haven't added any favorites yet.",
                                systemImageName: "heart.slash"
                            )
                            .padding(.top, 100)
                        } else {
                            ForEach(viewModel.favoriteMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieCardView(movie: movie)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
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

                if viewModel.isFetchingData {
                    LoadingOverlayView()
                }
            }
        }
    }
}
