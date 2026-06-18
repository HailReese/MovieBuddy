//
//  Movie.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 12.06.2026.
//

import Foundation

struct Movie: Codable {
    let title: String
    let year: Int
    let rating: Double
    let description: String
    let imageName: String
}

