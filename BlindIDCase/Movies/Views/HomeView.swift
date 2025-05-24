//
//  HomeView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isFethingData {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            MovieCardView(movie: movie)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
            .background(Color.black.opacity(0.3))
            .navigationTitle("Movies")
        }
        .onAppear {
            viewModel.fetchMoviesIfNeeded()
        }
    }
}
