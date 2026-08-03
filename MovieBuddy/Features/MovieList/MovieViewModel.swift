//
//  MovieListViewModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 19.06.2026.
//

import Foundation

@MainActor
class MovieViewModel {
    
    // MARK: - Properties
    private(set) var movies = Box<[MovieSearchItem]>([])
    
    func setupAddDelegate(for addMovie: AddMovieViewModel) {
        addMovie.delegate = self
    }
    func setupDetailDelegate(for movieDetail: MovieDetailViewModel) {
        movieDetail.delegate = self
    }
    
    private let storageManager = StorageService.shared
    
    func fetchMovieList() {
        Task {
            self.movies.value = await storageManager.load()
        }
    }
    
    func numberOfItems() -> Int {
        return movies.value.count
    }
    
    func getMovieByIndex(_ index: Int) -> MovieSearchItem {
        return movies.value[index]
    }
    
    private func saveMovies() {
        Task {
            await storageManager.save(movies.value)
        }
    }
}

extension MovieViewModel: AddMovieViewModelDelegate {
    func didAddMovie(_ movie: MovieSearchItem) {
        movies.value.append(movie)
        saveMovies()
    }
}

extension MovieViewModel: MovieDetailViewModelDelegate {
    func didDeleteMovie(at index: Int) {
        guard (movies.value.count > index) else { return }
        movies.value.remove(at: index)
        saveMovies()
    }
}
