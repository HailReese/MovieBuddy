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
    private(set) var totalPages: Int = 0
    private(set) var currentPage: Int = 1
    private(set) var currentQuery: String = ""
    private(set) var isLoading: Bool = false
    private(set) var isLoadingNextPage: Bool = false
    
    public var onMoviesUpdated: (() -> Void)?
    public var onLoadingStarted: (() -> Void)?
    public var onLoadingFinished: (() -> Void)?
    public var onLoadingNextPageStarted: (() -> Void)?
    public var onLoadingNextPageFinished: (() -> Void)?
    public var nextPageAvailable: (() -> Void)?
    public var nextPageUnavailable: (() -> Void)?
    public var onError: ((Error) -> Void)?
    
    func numberOfItems() -> Int {
        return movies.count
    }
    
    func getMovieByIndex(_ index: Int) -> MovieSearchItemResponse? {
        return movies[index]
    }
    
    func search(query: String) async throws {
        guard !isLoading else { return }
        
        isLoading = true
        self.onLoadingStarted?()
        
        currentQuery = query
        currentPage = 1
        
        defer {
            self.onLoadingFinished?()
            isLoading = false
        }
        
        do {
            let movies = try await MovieService.shared.search(query: query, page: currentPage)
            
            self.movies = movies.search
            guard let totalResults = Int(movies.totalResults) else { return }
            self.totalPages = totalResults % 10 == 0 ? totalResults / 10 : totalResults / 10 + 1
            
            self.onMoviesUpdated?()
            
        } catch {
            onError?(error)
            return
        }
        
        
        if currentPage < totalPages {
            self.nextPageAvailable?()
        } else {
            self.nextPageUnavailable?()
        }
    }
    
    func nextPage() async throws {
        guard currentPage < totalPages, !isLoadingNextPage else { return }
        
        isLoadingNextPage = true
        self.onLoadingNextPageStarted?()
        
        let nextPage = currentPage + 1
        
        defer {
            self.onLoadingNextPageFinished?()
            isLoadingNextPage = false
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
        
        if currentPage < totalPages {
            self.nextPageAvailable?()
        } else {
            self.nextPageUnavailable?()
        }
    }
}
