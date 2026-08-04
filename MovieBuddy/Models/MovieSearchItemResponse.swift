//
//  Movie.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 12.06.2026.
//

import Foundation

struct MovieSearchItemResponse: Codable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: URL
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

