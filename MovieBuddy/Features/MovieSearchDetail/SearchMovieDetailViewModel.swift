//
//  SearchMovieDetailViewModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 18.08.2026.
//

import Foundation

@MainActor
class SearchMovieDetailViewModel {
    private(set) var movie: MovieDetailResponse?
    private let id: String
    
    var dataIsLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(id: String) {
        self.id = id
    }
    
    func loadMovie() async {
        Task {
            do {
                movie = try await MovieService.shared.getMovie(id: id)
                dataIsLoaded?()
            } catch {
                onError?(error)
            }
        }
    }
}
