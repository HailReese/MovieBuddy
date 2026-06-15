//
//  AddMovieViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 14.06.2026.
//

import UIKit

protocol AddMovieViewControllerDelegate: AnyObject {
    func didAddMovie(_ movie: Movie)
}

class AddMovieViewController: UIViewController {
    
    weak var delegate: AddMovieViewControllerDelegate?
    
    //MARK: UI elements
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie name"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "Release year"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let field = PaddedTextField()
        field.placeholder = "Movie name"
        field.textColor = .label
        field.textAlignment = .left
        field.borderStyle = .none
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.keyboardType = .default
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let yearTextField: UITextField = {
        let field = PaddedTextField()
        field.placeholder = "Year"
        field.textColor = .label
        field.textAlignment = .left
        field.borderStyle = .none
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let ratingTextField: UITextField = {
        let field = PaddedTextField()
        field.placeholder = "Rating"
        field.textColor = .label
        field.textAlignment = .left
        field.borderStyle = .none
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let descTextView: UITextView = {
        let field = UITextView()
        field.font = .systemFont(ofSize: 16)
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New movie"
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelAddingMovie)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveNewMovie)
        )
        
        setupKeyboardHiding()
        uiExecutor()
    }
    
    @objc private func cancelAddingMovie() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveNewMovie() {
        guard let name = nameTextField.text, let year = yearTextField.text, let rating = ratingTextField.text else { return }
        delegate?.didAddMovie(
            Movie(title: name, year: Int(year) ?? 0, rating: Double(rating) ?? 0.0, description: descTextView.text ?? "", imageName: "")
        )
        
        dismiss(animated: true, completion: nil)
    }
    
    private func uiExecutor() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.setCustomSpacing(20, after: nameTextField)
        
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(yearTextField)
        stackView.setCustomSpacing(20, after: yearTextField)
        
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(ratingTextField)
        stackView.setCustomSpacing(20, after: ratingTextField)
        
        stackView.addArrangedSubview(descLabel)
        stackView.addArrangedSubview(descTextView)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            yearTextField.heightAnchor.constraint(equalToConstant: 44),
            ratingTextField.heightAnchor.constraint(equalToConstant: 44),
            descTextView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func setupKeyboardHiding() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        // Prevents touch delays on other components (buttons won't hang on the first tap)
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)  // Closes the keyboard across the entire view hierarchy
    }
}

class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
