//
//  HomeViewModel.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var favoriteMovies: [Movie] = []
    @Published var isFetchingData: Bool = false
    @Published var errorMessage: String?
    
    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    //HomeView' a her gelindiğinde istek atılsın isteniyorsa burası kaldırılabilir.
    func fetchMoviesIfNeeded() {
        guard movies.isEmpty else { return }
        Task {
            await fetchMovies()
        }
    }
    
    func fetchMovies() async {
        isFetchingData = true
        do {
            let fetchedMovies = try await movieService.fetchMovies()
            let likedMovieIDs = UserDataManager.shared.currentUser?.likedMovies ?? []
            movies = fetchedMovies.map { movie in
                var updated = movie
                updated.isLiked = likedMovieIDs.contains(movie.id)
                return updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isFetchingData = false
    }
    
    func filterFavoriteMovies() {
        favoriteMovies = movies.filter { $0.isLiked }
    }
    
    func refreshIsLikedStatesFromUser() {
        let likedIDs = UserDataManager.shared.currentUser?.likedMovies ?? []
        movies = movies.map { movie in
            var updated = movie
            updated.isLiked = likedIDs.contains(movie.id)
            return updated
        }
        filterFavoriteMovies()
    }
}
