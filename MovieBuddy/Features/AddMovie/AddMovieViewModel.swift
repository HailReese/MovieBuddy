//
//  AddMovieViewModel.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 22.06.2026.
//

import Foundation

// MARK: - Delegate Protocol
protocol AddMovieViewModelDelegate: AnyObject {
    func didAddMovie(_ movie: Movie)
}

class AddMovieViewModel {
    
    weak var delegate: AddMovieViewModelDelegate?
    
    var title: String?
    var year: String?
    var rating: String?
    var description: String?
    var imageName: String?
    
    let isValid = Box<Bool>(false)
    
    func saveMovie() {
        guard let name = self.title,
              let year = parseYear(for: self.year),
              let rating = parseRating(for: self.rating) else { return }
        
        let description = self.description ?? "none"
        
        let movie = Movie(title: name, year: year, rating: rating, description: description, imageName: "")
        delegate?.didAddMovie(movie)
    }
    
    func validateForm() {
        let isNameValid = !(title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = parseYear(for: year)
        let isYearValid = year != nil && (1800...currentYear).contains(year!)
        
        let rating = parseRating(for: rating)
        let isRatingValid = rating != nil && (0.0...10.0).contains(rating!)
        
        isValid.value = isNameValid && isYearValid && isRatingValid
    }
    
    func parseYear(for text: String?) -> Int? {
        guard let text = text else { return nil }
        return Int(text)
    }
    
    func parseRating(for text: String?) -> Double? {
        guard let text = text else { return nil }
        
        let formatter = NumberFormatter()
        
        formatter.decimalSeparator = "."
        if let number = formatter.number(from: text) { return number.doubleValue}
        
        formatter.decimalSeparator = ","
        if let number = formatter.number(from: text) { return number.doubleValue}
        
        return nil
    }
    
}
