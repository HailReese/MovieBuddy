//
//  MovieService.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 03.08.2026.
//

import Foundation

actor MediaService {
    static let shared = MediaService()
    private init() {}
    
    func getMedia<T: Decoder>(for endpoint: Endpoint) async throws -> T {
        let data = try await NetworkService.shared.getData(for: endpoint.request)
        
        
        
        
    }
}
