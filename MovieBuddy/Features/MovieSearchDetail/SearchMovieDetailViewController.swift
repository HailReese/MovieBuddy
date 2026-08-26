//
//  SearchMovieDetailViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 18.08.2026.
//

import UIKit

class SearchMovieDetailViewController: UIViewController {
    
    private let viewModel: SearchMovieDetailViewModel
    
    init(viewModel: SearchMovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releasedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plotLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        callbackHandler()
        Task {
            await viewModel.loadMovie()
        }
        
        testConfig()
    }
    
    private func callbackHandler() {
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
        
        viewModel.dataIsLoaded = { [weak self] in
            self?.setupBindings()
            self?.loadingIndicator.stopAnimating()
            self?.setupStackView()
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        )

        present(alert, animated: true)
    }
}

// MARK: - UI Setup & Layout
extension SearchMovieDetailViewController {
    
    private func testConfig() {
        title = ""
        yearLabel.text = "Test Year"
        ratedLabel.text = "Test Rated"
        releasedLabel.text = "Test Released"
        runtimeLabel.text = "Test Runtime"
        genreLabel.text = "Test Genre"
        directorLabel.text = "Test Director"
        plotLabel.text = "Test Plot"
    }
    
    private func setupLayout() {
        
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    private func setupStackView() {
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            // Важно: ширина контента = ширине ScrollView
            
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
            
        ])
        
        stackView.addArrangedSubview(posterImageView)
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(ratedLabel)
        stackView.addArrangedSubview(releasedLabel)
        stackView.addArrangedSubview(runtimeLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(directorLabel)
        stackView.addArrangedSubview(plotLabel)
    }
    
    private func setupBindings() {
        
        guard let movie = viewModel.movie else { return }
        title = movie.title
        yearLabel.text = movie.year
        ratedLabel.text = movie.rated
        releasedLabel.text = movie.released
        runtimeLabel.text = movie.runtime
        genreLabel.text = movie.genre
        directorLabel.text = movie.director
        plotLabel.text = movie.plot
    }
}
