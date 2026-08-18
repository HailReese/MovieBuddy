//
//  SearchMovieModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 05.08.2026.
//

import Foundation

@MainActor
class SearchMovieViewModel {
    
    private let pageSize: Int = 10
    
    private(set) var movies: [MovieSearchItemResponse] = []
    private(set) var totalPages: Int = 0
    private(set) var currentPage: Int = 1
    private(set) var currentQuery: String = ""
    private(set) var isLoading: Bool = false
    private(set) var isLoadingNextPage: Bool = false
    
    var onMoviesUpdated: (() -> Void)?
    var onLoadingStarted: (() -> Void)?
    var onLoadingFinished: (() -> Void)?
    var onLoadingNextPageStarted: (() -> Void)?
    var onLoadingNextPageFinished: (() -> Void)?
    var nextPageAvailable: (() -> Void)?
    var nextPageUnavailable: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func numberOfItems() -> Int {
        return movies.count
    }
    
    func getMovieByIndex(_ index: Int) -> MovieSearchItemResponse? {
        return movies[index]
    }
    
    func search(query: String) async {
        guard !isLoading else { return }
        
        isLoading = true
        self.onLoadingStarted?()
        
        currentQuery = query
        currentPage = 1
        
        defer {
            self.onLoadingFinished?()
            isLoading = false
            
            
            if currentPage < totalPages {
                self.nextPageAvailable?()
            } else {
                self.nextPageUnavailable?()
            }
        }
        
        do {
            let movies = try await MovieService.shared.search(query: query, page: currentPage)
            
            guard let totalResults = Int(movies.totalResults) else { return }
            self.totalPages = totalResults % pageSize == 0 ? totalResults / pageSize : totalResults / pageSize + 1
            
            self.movies = movies.search
            
            self.onMoviesUpdated?()
            
        } catch {
            onError?(error)
            return
        }
    }
    
    func nextPage() async {
        guard currentPage < totalPages, !isLoadingNextPage else { return }
        
        isLoadingNextPage = true
        self.onLoadingNextPageStarted?()
        
        let nextPage = currentPage + 1
        
        defer {
            self.onLoadingNextPageFinished?()
            isLoadingNextPage = false
            
            if currentPage < totalPages {
                self.nextPageAvailable?()
            } else {
                self.nextPageUnavailable?()
            }
        }
        
        do {
            
            let movies = try await MovieService.shared.search(query: currentQuery, page: nextPage)
            self.movies.append(contentsOf: movies.search)
            
            currentPage = nextPage
            
            self.onMoviesUpdated?()
        } catch {
            onError?(error)
            return
        }
    }
}
