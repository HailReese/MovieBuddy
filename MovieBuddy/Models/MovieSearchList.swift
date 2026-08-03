//
//  MovieSearchList.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 03.08.2026.
//

import Foundation

struct MovieSearchList: Codable {
    let search: [MovieSearchItem]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
