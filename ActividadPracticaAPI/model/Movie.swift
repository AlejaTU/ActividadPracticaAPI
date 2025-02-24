//
//  Movie.swift
//  ActividadPracticaAPI
//
//  Created by Alejandra Torres on 23/2/25.
//

import Foundation
struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let genre_ids: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case id, title, overview, genre_ids
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct MoviesResponse: Decodable {
    let results: [Movie]
}
