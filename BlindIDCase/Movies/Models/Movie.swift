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

enum MovieServiceError: Error {
    case invalidResponse
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Geçersiz sunucu yanıtı."
        case .decodingError(let error):
            return "Veri çözümlenemedi: \(error.localizedDescription)"
        }
    }
}
