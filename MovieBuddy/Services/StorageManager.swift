//
//  StorageManager.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 17.06.2026.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    private init(){}
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var path: URL = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return url[0]
    }()
    
    private lazy var fullPath: URL = {
        path.appendingPathComponent("movies.json")
    }()
    
    func save(_ items: [Movie]) {
        DispatchQueue.global().async {
            do {
                try self.encoder.encode(items).write(to: self.fullPath, options: .atomic)
            } catch {
                print("Ошибка сохранения: \(error.localizedDescription)")
            }
        }
    }
    
    func load(action: @escaping ([Movie]) -> Void) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: self.fullPath)
                let movies = try self.decoder.decode([Movie].self, from: data)
                action(movies)
            } catch {
                print("Не удалось загрузить фильмы: \(error.localizedDescription)")
                action([])
            }
        }
    }
}
