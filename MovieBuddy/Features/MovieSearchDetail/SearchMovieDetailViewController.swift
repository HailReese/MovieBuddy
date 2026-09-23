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
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let horizontalStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let horizontalStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
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
    
    private let yearLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let ratedLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let releasedLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let runtimeLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let genreLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let directorLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let writerLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let actorsLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let plotLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let languageLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let countryLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let awardsLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let ratingsLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let metascoreLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let imdbRatingLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let imdbVotesLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let imdbIDLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let typeLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let dvdLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    private let boxOfficeLabel = makeSectionLabel(numOfLines: 0, alignment: .natural)
    
    private let productionLabel = makeSectionLabel(numOfLines: 0, alignment: .center)
    
    private let websiteLabel = makeSectionLabel(numOfLines: 1, alignment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        callbackHandler()
        Task {
            await viewModel.loadMovie()
        }
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
private extension SearchMovieDetailViewController {
    
    func setupLayout() {
        
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
        
        scrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    func setupStackView() {
        
        horizontalStackView1.addArrangedSubview(yearLabel)
        horizontalStackView1.addArrangedSubview(runtimeLabel)
        horizontalStackView1.addArrangedSubview(ratedLabel)
        
        horizontalStackView2.addArrangedSubview(genreLabel)
        horizontalStackView2.addArrangedSubview(directorLabel)
        
        mainStackView.addArrangedSubview(posterImageView)
        mainStackView.addArrangedSubview(horizontalStackView1)
        mainStackView.addArrangedSubview(imdbRatingLabel)
        mainStackView.addArrangedSubview(horizontalStackView2)
        mainStackView.addArrangedSubview(plotLabel)
        mainStackView.addArrangedSubview(actorsLabel)
        mainStackView.addArrangedSubview(writerLabel)
        mainStackView.addArrangedSubview(languageLabel)
        mainStackView.addArrangedSubview(countryLabel)
        
    }
    
    func setupBindings() {
        
        guard let movie = viewModel.movie else { return }
        title = movie.title
        yearLabel.text = "Year: \(movie.year)"
        ratedLabel.text = "Rated: \(movie.rated)"
        releasedLabel.text = "Released: \(movie.released)"
        runtimeLabel.text = "Runtime: \(movie.runtime)"
        genreLabel.text = "Genre: \(movie.genre)"
        directorLabel.text = "Director: \(movie.director)"
        plotLabel.text = "Plot: \(movie.plot)"
        imdbRatingLabel.text = "IMDb Rating: \(movie.imdbRating)"
        actorsLabel.text = "Actors: \(movie.actors)"
        writerLabel.text = "Writer: \(movie.writer)"
        languageLabel.text = "Language: \(movie.language)"
        countryLabel.text = "Country: \(movie.country)"
    }
}

// MARK: - Other
private extension SearchMovieDetailViewController {
    
    static func makeSectionLabel(numOfLines: Int, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = numOfLines
        label.textAlignment = alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
