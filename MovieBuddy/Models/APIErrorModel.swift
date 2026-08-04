//
//  APIErrorModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 05.08.2026.
//

import Foundation

struct APIErrorModel: Codable {
    
    let response: String
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}
