//
//  MovieDetailViewModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 19.06.2026.
//

import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    func didDeleteMovie(at index: Int)
}

class MovieDetailViewModel {
    
    let title: String
    let year: String
    let rating: String
    let description: String
    let imageName: String
    private let indexInArray: Int
    
    weak var delegate: MovieDetailViewModelDelegate?
    
    init(movie: Movie, at index: Int) {
        self.title = movie.title
        self.year = "Year: \(String(movie.year))"
        self.rating = "Rating: \(String(movie.rating))"
        self.description = movie.description
        self.imageName = movie.imageName
        self.indexInArray = index
    }
    
    func deleteMovie() {
        delegate?.didDeleteMovie(at: indexInArray)
    }
}
