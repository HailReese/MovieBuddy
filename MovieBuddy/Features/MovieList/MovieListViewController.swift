//
//  ViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 10.06.2026.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private let viewModel = MovieListViewModel()
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
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
private extension MovieListViewController {
    
    func setupBindings() {
        viewModel.movies.bind{ [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(addButtonTapped)
        )
    }
}

// MARK: - @objc methods
extension MovieListViewController {
    @objc private func addButtonTapped() {
        let addVM = AddMovieViewModel()
        viewModel.setupAddDelegate(for: addVM)
        let addVC = AddMovieViewController(viewModel: addVM)
        
        let navigationController = UINavigationController(rootViewController: addVC)
        
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = viewModel.getMovieByIndex(indexPath.row)
        
        cell.configure(for: movie)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMovie = viewModel.getMovieByIndex(indexPath.row)
        
        let detailVM = MovieDetailViewModel(movie: selectedMovie, at: indexPath.row)
        viewModel.setupDetailDelegate(for: detailVM)
        let detailVC = MovieDetailViewController(viewModel: detailVM)
        
        navigationController?.pushViewController(detailVC, animated: true)
        
        //print("Пользователь нажал на фильм: \(selectedMovie)")
    }
}
