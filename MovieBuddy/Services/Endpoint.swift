//
//  Endpoint.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 03.08.2026.
//

import Foundation

enum Endpoint {
    case search(query: String)
    case getById(for: String)
    case getByTitle(for: String)
    
    var url: URL {
        switch self {
        case .search(let query):
            return buildURL(query: [URLQueryItem(name: "apikey", value: "2e2d30fc"), URLQueryItem(name: "s", value: query)])
        case .getById(let query):
            return buildURL(query: [URLQueryItem(name: "apikey", value: "2e2d30fc"), URLQueryItem(name: "i", value: query)])
        case .getByTitle(let query):
            return buildURL(query: [URLQueryItem(name: "apikey", value: "2e2d30fc"), URLQueryItem(name: "t", value: query)])
        }
    }
    
    var request: URLRequest {
        buildRequest()
    }
    
    private func buildURL(query: [URLQueryItem]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.omdbapi.com"
        components.path = "/"
        components.queryItems = query
        return components.url!
    }
    
    private func buildRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

}
