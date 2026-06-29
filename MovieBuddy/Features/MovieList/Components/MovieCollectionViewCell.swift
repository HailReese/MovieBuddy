//
//  MovieCollectionViewCell.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 26.06.2026.
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
    
    private var gridConstraints: [NSLayoutConstraint] = []
    private var tableConstraints: [NSLayoutConstraint] = []
    
    private let titleLabel = makeLabel(color: .systemBlue, font: .systemFont(ofSize: 17), numOfLines: 1)
    private let yearLabel = makeLabel(color: .label, font: .systemFont(ofSize: 13), numOfLines: 1)
    private let ratingLabel = makeLabel(color: .label, font: .systemFont(ofSize: 13), numOfLines: 1)
    private let descLabel = makeLabel(color: .label, font: .systemFont(ofSize: 11), numOfLines: 3)
    
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
        contentView.addSubview(descLabel)
        
        gridConstraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor,constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
//            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            ratingLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -5),
            ratingLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor)
        ]
        
        tableConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: posterImageView.bottomAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor,constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            ratingLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            descLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 5),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ]
    }
    
    static func makeLabel(color: UIColor, font: UIFont, numOfLines: Int) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = font
        label.numberOfLines = numOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

// MARK: - Configuration
internal extension MovieCollectionViewCell {
    func configure(for movie: Movie, isGrid isGridEnabled: Bool) {
        
        titleLabel.text = movie.title
        yearLabel.text = "Year: \(movie.year)"
        ratingLabel.text = "Rating: \(movie.rating)"
        descLabel.text = movie.description
        posterImageView.image = UIImage(named: movie.imageName)
        
        NSLayoutConstraint.deactivate(gridConstraints + tableConstraints)
        
        if isGridEnabled {
            NSLayoutConstraint.activate(gridConstraints)
            descLabel.isHidden = true
        } else {
            NSLayoutConstraint.activate(tableConstraints)
            descLabel.isHidden = false
        }
    }
}
