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

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        viewModel.onMoviesUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
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
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.dataSource = self
//        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: isGridLayout ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(changeLayout)
        )
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
}

// MARK: - UISearchResultsUpdating
extension SearchMovieViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        Task {
            try await viewModel.search(query: searchText)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchMovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SEARCH BUTTON")

        guard let query = searchBar.text,
              !query.isEmpty else {
            print("QUERY EMPTY")
            return
        }

        print("QUERY:", query)

        Task {
            do {
                try await viewModel.search(query: query)
                print("SEARCH SUCCESS")
            } catch {
                print("SEARCH ERROR:", error)
            }
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

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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
