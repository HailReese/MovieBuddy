//
//  MovieDetailViewModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 19.06.2026.
//

import Foundation

class MovieDetailViewModel {
    
    let title: String
    let year: String
    let rating: String
    let description: String
    let imageName: String
    
    init(_ movie: Movie) {
        self.title = movie.title
        self.year = "Year: \(String(movie.year))"
        self.rating = "Rating: \(String(movie.rating))"
        self.description = movie.description
        self.imageName = movie.imageName
    }
}
