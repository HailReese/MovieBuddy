//
//  MovieService.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 03.08.2026.
//

import Foundation

actor MovieService {
    static let shared = MovieService()
    private init() {}
    
    private let decoder = JSONDecoder.movieBuddy
    
    func search(query: String) async throws -> MovieSearchListResponse {
        
        let endpoint = Endpoint.search(query: query)
        let movies: MovieSearchListResponse = try await decode(endpoint: endpoint)
        
        return movies
    }
    
    func getMovie(id query: String) async throws -> MovieDetailResponse {
        let endpoint = Endpoint.getById(for: query)
        let movie: MovieDetailResponse = try await decode(endpoint: endpoint)
        return movie
    }
    
    func getMovie(title query: String) async throws -> MovieDetailResponse {
        let endpoint = Endpoint.getByTitle(for: query)
        let movie: MovieDetailResponse = try await decode(endpoint: endpoint)
        
        return movie
    }
    
    private func decode<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let data = try await NetworkService.shared.perform(for: endpoint.request)
        
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
                throw NetworkError.apiError(apiError.error)
            }
            throw error
        }
    }
}
