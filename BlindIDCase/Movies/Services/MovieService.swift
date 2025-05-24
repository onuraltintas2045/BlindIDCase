//
//  MovieService.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    private let baseURL = URL(string: "https://moviatask.cerasus.app/api/movies")!

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
}
