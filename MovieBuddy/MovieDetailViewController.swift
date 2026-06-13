//
//  MovieDetailViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 13.06.2026.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Elements
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = movie.title
        uiExecutor()

        // Do any additional setup after loading the view.
    }
    
    private func uiExecutor() {
        view.addSubview(posterImageView)
        view.addSubview(yearLabel)
        view.addSubview(ratingLabel)
        view.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 500),
            posterImageView.widthAnchor.constraint(equalToConstant: 300),
            
            yearLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            yearLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 12),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            descLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
        ])
        
        loadMovieData(for: movie)
    }

    private func loadMovieData(for movie: Movie) {
        yearLabel.text = "Year: \(String(movie.year))"
        ratingLabel.text = "Rating: \(String(movie.rating))"
        descLabel.text = movie.description
    }
}
