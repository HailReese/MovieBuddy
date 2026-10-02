//
//  SearchMovieDetailViewModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 18.08.2026.
//

import Foundation
import UIKit

@MainActor
class SearchMovieDetailViewModel {
    private(set) var movie: MovieDetailResponse?
    private(set) var image: UIImage?
    private let id: String
    
    var dataIsLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(id: String) {
        self.id = id
    }
    
    func loadMovie() async {
        do {
            movie = try await MovieService.shared.getMovie(id: id)
            if let url = movie?.poster {
                image = try await ImageLoader.shared.loadImage(url)
            }
            dataIsLoaded?()
        } catch {
            onError?(error)
        }
    }
}
