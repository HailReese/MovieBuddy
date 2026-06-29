//
//  MovieGridViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 24.06.2026.
//

import UIKit

class MovieViewController: UIViewController {
    
    private let viewModel = MovieViewModel()
    private var isGridLayout = false
    
    // MARK: - UI Elements
    
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
        title = "Movies"
        view.backgroundColor = .systemBackground
        viewModel.fetchMovieList()
        setupLayout()
        setupNavigationBar()
        setupBindings()
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
private extension MovieViewController {
    
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
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: isGridLayout ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(changeLayout)
        )
    }
}

// MARK: - @objc methods
extension MovieViewController {
    @objc private func addButtonTapped() {
        let addVM = AddMovieViewModel()
        viewModel.setupAddDelegate(for: addVM)
        let addVC = AddMovieViewController(viewModel: addVM)
        
        let navigationController = UINavigationController(rootViewController: addVC)
        
        present(navigationController, animated: true, completion: nil)
    }
    
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

// MARK: - UICollectionViewDataSource
extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        let movie = viewModel.getMovieByIndex(indexPath.row)
        
        cell.configure(for: movie, isGrid: isGridLayout)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedMovie = viewModel.getMovieByIndex(indexPath.row)
        
        let detailVM = MovieDetailViewModel(movie: selectedMovie, at: indexPath.row)
        viewModel.setupDetailDelegate(for: detailVM)
        let detailVC = MovieDetailViewController(viewModel: detailVM)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
