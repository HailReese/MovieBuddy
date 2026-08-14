//
//  SearchMovieModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 05.08.2026.
//

import Foundation

@MainActor
class SearchMovieViewModel {
    
    private(set) var movies: [MovieSearchItemResponse] = []
    
    public var onMoviesUpdated: (() -> Void)?
    
    func numberOfItems() -> Int {
        return movies.count
    }
    
    func getMovieByIndex(_ index: Int) -> MovieSearchItemResponse? {
        return movies[index]
    }
    
    func search(query: String) async throws {
        let movies = try await MovieService.shared.search(query: query)
        self.movies = movies.search
            self.onMoviesUpdated?()
    }
}
