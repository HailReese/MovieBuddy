//
//  Box.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 19.06.2026.
//

import Foundation

public class Box<T> {
    var listener: ((T) -> Void)?
    
    var value: T {
        didSet { listener?(value)}
    }
    
    init(_ value: T) { self.value = value}
    
    func bind(_ listener: @escaping ((T) -> Void)) {
        self.listener = listener
        listener(value)
    }
}
