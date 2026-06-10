//
//  ViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 10.06.2026.
//

import UIKit

class MovieListViewController: UIViewController {
    
    let movies = ["Seven", "Hulk", "Scream", "Iron Man", "Dark Knight"]
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        
        
        
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
    
    // 1. Вопрос таблицы: "Сколько строк мне нарисовать?"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        // ТВОЙ КОД: Верни количество элементов из массива movies
    }
    
    // 2. Вопрос таблицы: "Дай мне готовую ячейку для строки №..."
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // а) Вытаскиваем свободную ячейку из пула переиспользования
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        // б) ТВОЙ КОД: Достань правильное название фильма из массива movies.
        // Индекс текущей строки хранится в indexPath.row
        let movieTitle = movies[indexPath.row]
        
        // в) Настраиваем внешний вид ячейки (iOS 14+)
        var content = cell.defaultContentConfiguration()
        content.text = movieTitle
        cell.contentConfiguration = content
        
        // г) Отдаем готовую ячейку таблице
        return cell
    }
}
