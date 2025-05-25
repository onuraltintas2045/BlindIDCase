//
//  HomeView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: HomeViewModel

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Movie List, EmptyView
                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.movies.isEmpty {
                            EmptyStateView(
                                title: "No Movies",
                                message: "There are no movies to display. Please try again later.",
                                systemImageName: "film"
                            )
                            .padding(.top, 100)
                        } else {
                            ForEach(viewModel.movies) { movie in
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
                .navigationTitle("Movies")
                .onAppear {
                    viewModel.fetchMoviesIfNeeded()
                }

                if viewModel.isFetchingData {
                    LoadingOverlayView()
                }
            }
        }
    }
}
