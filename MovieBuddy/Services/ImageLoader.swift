//
//  ImageService.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 24.09.2026.
//

import Foundation
import UIKit

actor ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func loadImage(_ url: URL) async throws -> UIImage? {
        
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        } else {
            let data = try await NetworkService.shared.perform(for: URLRequest(url: url))
            let image = UIImage(data: data)
            return image
        }
    }
}
