//
//  JSONEncoder+MovieBuddy.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 05.08.2026.
//

import Foundation

extension JSONEncoder {
    static var movieBuddy: JSONEncoder {
        let encoder = JSONEncoder()
        return encoder
    }
}
