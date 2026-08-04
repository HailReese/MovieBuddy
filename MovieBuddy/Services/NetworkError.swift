//
//  NetworkError.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 04.08.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidStatusCode(Int)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
        case .apiError(let message):
            return message
        }
    }
}
