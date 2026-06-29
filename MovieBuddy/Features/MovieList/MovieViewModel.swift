//
//  MovieListViewModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 19.06.2026.
//

import Foundation

class MovieViewModel {
    
    // MARK: - Properties
    private(set) var movies = Box<[Movie]>([])
    
    func setupAddDelegate(for addMovie: AddMovieViewModel) {
        addMovie.delegate = self
    }
    func setupDetailDelegate(for movieDetail: MovieDetailViewModel) {
        movieDetail.delegate = self
    }
    
    private let storageManager = StorageManager.shared
    
    func fetchMovieList() {
        let savedMovies = storageManager.load()
        movies.value = savedMovies
    }
    
    func numberOfItems() -> Int {
        return movies.value.count
    }
    
    func getMovieByIndex(_ index: Int) -> Movie {
        return movies.value[index]
    }
    
    private func saveMovies() {
        storageManager.save(movies.value)
    }
}

extension MovieViewModel: AddMovieViewModelDelegate {
    func didAddMovie(_ movie: Movie) {
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
