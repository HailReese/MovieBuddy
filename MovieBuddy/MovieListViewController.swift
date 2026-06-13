//
//  ViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 10.06.2026.
//

import UIKit

class MovieListViewController: UIViewController {
    
    var movies: [Movie] = [
        Movie(title: "Seven", year: 1995, rating: 8.6, description: "Two detectives hunt a serial killer.", imageName: "seven"),
        Movie(title: "Hulk", year: 2003, rating: 5.6, description: "Bruce Banner transforms into a powerful green monster.", imageName: "hulk"),
        Movie(title: "The Dark Knight", year: 2008, rating: 9.0, description: "Batman faces his ultimate enemy, the Joker.", imageName: "the_dark_knight"),
        Movie(title: "Pride & Prejudice", year: 2005, rating: 7.8, description: "When Elizabeth Bennet meets the handsome Mr. Darcy, she believes he is the last man she could ever marry, but as their lives become intertwined, she finds herself captivated by the man she has sworn to hate forever.", imageName: "pride_and_prejudice"),
        Movie(title: "Incendies", year: 2010, rating: 8.3, description: "Twins journey to the Middle East to discover their family history and fulfill their mother's last wishes.", imageName: "incendies"),
        Movie(title: "Ford v Ferrari", year: 2019, rating: 8.1, description: "American car designer Carroll Shelby and driver Ken Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order to defeat Ferrari at the 24 Hours of Le Mans in 1966.", imageName: "ford_v_ferrari"),
        Movie(title: "Backrooms", year: 2026, rating: 7.1, description: "After a therapist's patient disappears into a dimension beyond reality, she must venture into the unknown to save him.", imageName: "backrooms"),
        Movie(title: "Obsession", year: 2025, rating: 8.1, description: "After breaking the mysterious \"One Wish Willow\" to win his crush's heart, a hopeless romantic finds himself getting exactly what he asked for but soon discovers that some desires come at a dark, sinister price.", imageName: "obsession"),
        Movie(title: "Project Hail Mary", year: 2026, rating: 8.3, description: "A science teacher wakes up alone on a spaceship. As his memory returns, he uncovers a mission to stop a mysterious substance killing Earth's sun, and realizes that an unexpected friendship may be the key.", imageName: "project_hail_mary")
        
    ]
    
    // MARK: UI Elements
    
    let tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
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
        
        let detailVC = MovieDetailViewController(movie: selectedMovie)
        
        navigationController?.pushViewController(detailVC, animated: true)
        
        print("Пользователь нажал на фильм: \(selectedMovie)")
    }
}
