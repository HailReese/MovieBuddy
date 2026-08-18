//
//  SearchMovieViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 05.08.2026.
//

import UIKit

class SearchMovieViewController: UIViewController {
    
    private let viewModel = SearchMovieViewModel()
    private var isGridLayout = false
    
    // MARK: - UI Elements
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.searchBarStyle = .minimal
        search.searchBar.placeholder = "Search for a movie"
        return search
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingNewPageIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let nextPageButton: UIButton = {
        var config = UIButton.Configuration.glass()
        config.title = "Load more"
        config.baseBackgroundColor = .secondarySystemBackground
        config.baseForegroundColor = .label
        config.cornerStyle = .capsule

        let button = UIButton(configuration: config)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    private let gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }()
    
    private let tableLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let item = UICollectionView(frame: .zero, collectionViewLayout: tableLayout)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupLayout()
        callbackHandler()

//        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateLayoutSize()
    }

    private func updateLayoutSize() {
        tableLayout.itemSize = CGSize(
            width: view.frame.width,
            height: 120
        )
        
        gridLayout.itemSize = CGSize(
            width: (view.frame.width - 32) / 2,
            height: ((view.frame.width - 32) / 2) * 1.7
        )
    }
}

// MARK: - UI Setup & Layout
private extension SearchMovieViewController {
    
    func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(nextPageButton)
        view.addSubview(loadingIndicator)
        view.addSubview(loadingLabel)
        view.addSubview(loadingNewPageIndicator)
        
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.dataSource = self
//        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: nextPageButton.topAnchor),
            nextPageButton.heightAnchor.constraint(equalToConstant: 50),
            nextPageButton.widthAnchor.constraint(equalToConstant: 150),
            nextPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextPageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: nextPageButton.centerYAnchor),
            loadingLabel.centerXAnchor.constraint(equalTo: nextPageButton.centerXAnchor, constant: 10),
            loadingNewPageIndicator.centerYAnchor.constraint(equalTo: nextPageButton.centerYAnchor),
            loadingNewPageIndicator.trailingAnchor.constraint(equalTo: loadingLabel.leadingAnchor, constant: -5)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: isGridLayout ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(changeLayout)
        )
        nextPageButton.addTarget(self, action: #selector(loadNextPage), for: .touchUpInside)
    }
    
    func callbackHandler() {
        viewModel.onMoviesUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.nextPageAvailable = { [weak self] in
            self?.nextPageButton.isHidden = false
            self?.nextPageButton.isEnabled = true
        }
        
        viewModel.nextPageUnavailable = { [weak self] in
            self?.nextPageButton.isHidden = true
            self?.nextPageButton.isEnabled = false
        }
        
        viewModel.onLoadingStarted = { [weak self] in
            self?.loadingIndicator.startAnimating()
        }
        
        viewModel.onLoadingFinished = { [weak self] in
            self?.loadingIndicator.stopAnimating()
        }
        
        viewModel.onLoadingNextPageStarted = { [weak self] in
            self?.nextPageButton.isHidden = true
            self?.loadingLabel.isHidden = false
            self?.loadingNewPageIndicator.startAnimating()
        }
        
        viewModel.onLoadingNextPageFinished = { [weak self] in
            self?.nextPageButton.isHidden = false
            self?.loadingLabel.isHidden = true
            self?.loadingNewPageIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
}

// MARK: - @objc methods
extension SearchMovieViewController {
    
    @objc private func changeLayout() {
        isGridLayout.toggle()
        
        navigationItem.leftBarButtonItem?.image = isGridLayout
        ? UIImage(systemName: "list.bullet")
        : UIImage(systemName: "square.grid.2x2")
        
        collectionView.setCollectionViewLayout(
            isGridLayout ? gridLayout : tableLayout,
            animated: false
        ) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func loadNextPage() {
        Task {
            await viewModel.nextPage()
        }
    }
}

// MARK: - UISearchResultsUpdating
//extension SearchMovieViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text else { return }
//        Task {
//            try await viewModel.search(query: searchText)
//        }
//    }
//}

// MARK: - UISearchBarDelegate
extension SearchMovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let query = searchBar.text,
              !query.isEmpty else {
            return
        }

        Task {
            await viewModel.search(query: query.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SearchMovieViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MovieCell",
            for: indexPath
        ) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let movie = viewModel.getMovieByIndex(indexPath.item) else {
            return cell
        }

        cell.configure(for: movie, isGrid: isGridLayout)

        return cell
    }
}

//// MARK: - UICollectionViewDelegate
//extension SearchMovieViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        let selectedMovie = viewModel.getMovieByIndex(indexPath.row)
//        
//        let detailVM = MovieDetailViewModel(movie: selectedMovie, at: indexPath.row)
//        viewModel.setupDetailDelegate(for: detailVM)
//        let detailVC = MovieDetailViewController(viewModel: detailVM)
//        
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//}
