//
//  MovieGridViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 24.06.2026.
//

import UIKit

class MovieGridViewController: UIViewController {
    
    private let viewModel = MovieListViewModel()
    
    // MARK: - UI Elements
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let item = UICollectionViewFlowLayout()
        item.itemSize.width = 100
        item.itemSize.height = 150
        item.scrollDirection = .vertical
        item.minimumLineSpacing = 16
        item.minimumInteritemSpacing = 16
        return item
    }()
    
    private lazy var collectionView: UICollectionView = {
        let item = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        viewModel.fetchMovieList()
        setupLayout()
        setupNavigationBar()
        setupBindings()
    }
}

// MARK: - UI Setup & Layout
private extension MovieGridViewController {
    
    func setupBindings() {
        viewModel.movies.bind{ [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(addButtonTapped)
        )
    }
}

// MARK: - @objc methods
extension MovieGridViewController {
    @objc private func addButtonTapped() {
        let addVM = AddMovieViewModel()
        viewModel.setupAddDelegate(for: addVM)
        let addVC = AddMovieViewController(viewModel: addVM)
        
        let navigationController = UINavigationController(rootViewController: addVC)
        
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension MovieGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        let movie = viewModel.getMovieByIndex(indexPath.row)
        
        cell.configure(for: movie)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedMovie = viewModel.getMovieByIndex(indexPath.row)
        
        let detailVM = MovieDetailViewModel(movie: selectedMovie, at: indexPath.row)
        viewModel.setupDetailDelegate(for: detailVM)
        let detailVC = MovieDetailViewController(viewModel: detailVM)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
