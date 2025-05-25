//
//  MovieService.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
    func likeMovie(movieId: Int) async throws -> [Int]
    func unlikeMovie(movieId: Int) async throws -> [Int]
}

final class MovieService: MovieServiceProtocol {
    private let baseURL = URL(string: "https://moviatask.cerasus.app/api/movies/")!
    
    func fetchMovies() async throws -> [Movie] {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }

        do {
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            throw MovieServiceError.decodingError(error)
        }
    }
    
    func likeMovie(movieId: Int) async throws -> [Int] {
        try await sendLikeUnlikeRequest(endpoint: "like/\(movieId)")
    }
    
    func unlikeMovie(movieId: Int) async throws -> [Int] {
        try await sendLikeUnlikeRequest(endpoint: "unlike/\(movieId)")
    }
    
    private func sendLikeUnlikeRequest(endpoint: String) async throws -> [Int] {
        guard let token = KeychainManager.readToken() else {
            throw MovieServiceError.missingToken
        }
        
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw MovieServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }
        
        do {
            let decoded = try JSONDecoder().decode(LikeMovieResponse.self, from: data)
            return decoded.likedMovies
        } catch {
            throw MovieServiceError.decodingError(error)
        }
    }
}
