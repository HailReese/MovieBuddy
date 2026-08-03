//
//  Endpoint.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 03.08.2026.
//

import Foundation

enum Endpoint {
    case search(query: String, type: String, year: String, page: String)
    case getById(for: String)
    case getByTitle(for: String)
    
    private static let apiKey = "2e2d30fc"
    
    var url: URL {
        switch self {
        case .search(let query, let type, let year, let page):
            return buildURL(query: [
                URLQueryItem(name: "s", value: query),
                URLQueryItem(name: "type", value: type),
                URLQueryItem(name: "y", value: year),
                URLQueryItem(name: "page", value: page)])
        case .getById(let query):
            return buildURL(query: [URLQueryItem(name: "i", value: query)])
        case .getByTitle(let query):
            return buildURL(query: [URLQueryItem(name: "t", value: query)])
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
        components.queryItems?.append(URLQueryItem(name: "apikey", value: Endpoint.apiKey))
        return components.url!
    }
    
    private func buildRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

}
