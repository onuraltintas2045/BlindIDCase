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
    @Published var movie: Movie
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?

    private let movieService: MovieServiceProtocol

    init(movie: Movie, movieService: MovieServiceProtocol = MovieService()) {
        self.movie = movie
        self.movieService = movieService
    }

    func toggleFavoriteStatus() async {
        guard !isProcessing else { return }
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

        } catch {
            errorMessage = "Bir hata oluştu: \(error.localizedDescription)"
        }

        isProcessing = false
    }
}
