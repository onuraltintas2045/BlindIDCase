//
//  MovieDetailViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 25.05.2025.
//

import Foundation
// TODO: - Favorite - Unfavorite akışı kesinlikle düzenlenmeli
@MainActor
final class MovieDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var movie: Movie
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // MARK: - Dependencies
    private let movieService: MovieServiceProtocol

    // MARK: - Init
    init(movie: Movie, movieService: MovieServiceProtocol = MovieService()) {
        self.movie = movie
        self.movieService = movieService
    }
    
    // MARK: - Public Methods
    func toggleFavorite() {
        guard !isProcessing else { return }

        Task {
            await performToggleFavorite()
        }
    }

    // MARK: - Private Methods
    private func performToggleFavorite() async {
        isProcessing = true
        errorMessage = nil

        do {
            let updatedLikedIDs: [Int]
            if movie.isLiked {
                updatedLikedIDs = try await movieService.unlikeMovie(movieId: movie.id)
            } else {
                updatedLikedIDs = try await movieService.likeMovie(movieId: movie.id)
            }

            movie.isLiked = updatedLikedIDs.contains(movie.id)
            UserDataManager.shared.updateLikedMovies(likedMovies: updatedLikedIDs)

        } catch let error as MovieServiceError {
            errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            errorMessage = "An unknown error occurred."
            self.showError = true
        }

        isProcessing = false
    }
}
