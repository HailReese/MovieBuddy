//
//  ViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 10.06.2026.
//

import UIKit

class MovieListViewController: UIViewController {
    
    var movies: [Movie] = [
        Movie(title: "Seven", year: 1995, rating: 8.6, description: "Two detectives hunt a serial killer."),
        Movie(title: "Hulk", year: 2003, rating: 5.6, description: "Bruce Banner transforms into a powerful green monster."),
        Movie(title: "The Dark Knight", year: 2008, rating: 9.0, description: "Batman faces his ultimate enemy, the Joker.")
    ]
    
    // MARK: UI Elements
    
    let tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiExecutor()
        // Do any additional setup after loading the view.
    }
}

// MARK: UI Setup & Layout
extension MovieListViewController {
    func uiExecutor() {
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
}

// MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        
//        var content = cell.defaultContentConfiguration()
//        content.text = movieTitle
        cell.configure(for: movie)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMovie = movies[indexPath.row]
        
        print("Пользователь нажал на фильм: \(selectedMovie)")
    }
}
