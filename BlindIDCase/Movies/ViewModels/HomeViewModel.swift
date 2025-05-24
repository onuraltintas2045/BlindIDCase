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
    @Published var isFethingData: Bool = false
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
        isFethingData = true
        do {
            let fetchedMovies = try await movieService.fetchMovies()
            movies = fetchedMovies
        } catch {
            errorMessage = error.localizedDescription
        }
        isFethingData = false
    }
    
    func filterFavoriteMovies() {
        guard let favoriteMovieIDs = UserDataManager.shared.currentUser?.likedMovies else {
            favoriteMovies = movies
            return
        }
        favoriteMovies = movies.filter { favoriteMovieIDs.contains($0.id) }
    }
}
