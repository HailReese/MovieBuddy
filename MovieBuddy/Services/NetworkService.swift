//
//  NetworkManager.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 29.07.2026.
//

import Foundation

actor NetworkService {
    static let shared = NetworkService()
    private init(){}
    
    func perform(for request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
}
