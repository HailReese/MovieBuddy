//
//  MovieCollectionViewCell.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 25.06.2026.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel = makeLabel(color: .systemBlue, font: .systemFont(ofSize: 15), textAlignment: .center)
    private let yearLabel = makeLabel(color: .label, font: .systemFont(ofSize: 13), textAlignment: .left)
    private let ratingLabel = makeLabel(color: .systemYellow, font: .systemFont(ofSize: 13), textAlignment: .right)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup & Layout
private extension MovieCollectionViewCell {
    func setupLayout() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor,constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor)
        ])
    }
    
    static func makeLabel(color: UIColor, font: UIFont, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = font
        label.textAlignment = textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

// MARK: - Configuration
internal extension MovieCollectionViewCell {
    func configure(for movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = "\(String(movie.year))"
        ratingLabel.text = "\(String(movie.rating))"
        posterImageView.image = UIImage(named: movie.imageName)
    }
}
