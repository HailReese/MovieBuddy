//
//  MovieDetailViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 13.06.2026.
//

import UIKit

// MARK: - Main
class MovieDetailViewController: UIViewController {
    
    private let viewModel: MovieDetailViewModel
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - UI Elements
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descLabel: UILabel = {
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
        
        setupLayout()
        setupNavigationBar()
        setupBindings()
    }
}

// MARK: - UI Setup & Layout
private extension MovieDetailViewController {
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteMovie)
        )
    }
    
    func setupLayout() {
        view.addSubview(posterImageView)
        view.addSubview(yearLabel)
        view.addSubview(ratingLabel)
        view.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 300),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            yearLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            yearLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 12),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            descLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
        ])
    }
    
    private func setupBindings() {
        title = viewModel.title
        yearLabel.text = viewModel.year
        ratingLabel.text = viewModel.rating
        descLabel.text = viewModel.description
        posterImageView.image = UIImage(named: viewModel.imageName)
    }
}

extension MovieDetailViewController {
    @objc private func deleteMovie() {
        viewModel.deleteMovie()
        navigationController?.popViewController(animated: true)
    }
}
