//
//  Genre.swift
//  ActividadPracticaAPI
//
//  Created by Alejandra Torres on 23/2/25.
//

import Foundation
struct Genre: Decodable {
    let id: Int
    let name: String
}

struct GenresResponse: Decodable {
    let genres: [Genre]
}
