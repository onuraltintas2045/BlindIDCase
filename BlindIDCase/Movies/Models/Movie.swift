//
//  Movie.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let year: Int
    let rating: Double
    let actors: [String]
    let category: String
    let posterUrl: String
    let description: String
    
    var isLiked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case rating
        case actors
        case category
        case posterUrl = "poster_url"
        case description
    }
}

struct LikeMovieResponse: Codable {
    let message: String
    let likedMovies: [Int]
}

enum MovieServiceError: Error, LocalizedError {
    case invalidResponse
    case decodingError(Error)
    case missingToken
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Sunucudan geçerli bir yanıt alınamadı."
        case .decodingError(let error):
            return "Veri çözümlenemedi: \(error.localizedDescription)"
        case .missingToken:
            return "Kullanıcı doğrulama bilgisi eksik."
        case .invalidURL:
            return "URL hatalı."
        }
    }
}
