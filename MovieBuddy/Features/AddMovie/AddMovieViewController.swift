//
//  AddMovieViewController.swift
//  MovieBuddy
//
//  Created by Сабит Бектуров on 14.06.2026.
//

import UIKit

// MARK: - Main
class AddMovieViewController: UIViewController {
    
    private let viewModel: AddMovieViewModel
    
    init(viewModel: AddMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI elements
    private let nameLabel = makeSectionLabel("Movie name")
    private let yearLabel = makeSectionLabel("Release year")
    private let ratingLabel = makeSectionLabel("Rating")
    private let descLabel = makeSectionLabel("Description")
    private let nameTextField = PaddedTextField(placeholder: "Movie name", keyboardType: .default)
    private let yearTextField = PaddedTextField(placeholder: "Year", keyboardType: .numberPad)
    private let ratingTextField = PaddedTextField(placeholder: "Rating", keyboardType: .decimalPad)
    
    private let descTextView: UITextView = {
        let field = UITextView()
        field.font = .systemFont(ofSize: 16)
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New movie"
        
        setupKeyboardHiding()
        setupLayout()
        setupNavigationBar()
        setupFieldActions()
        setupBindings()
    }
}

// MARK: - UI Setup & Layout
private extension AddMovieViewController {
    
    func setupNavigationBar() {
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
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupLayout() {
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
            //yearPicker.heightAnchor.constraint(equalToConstant: 44),
            ratingTextField.heightAnchor.constraint(equalToConstant: 44),
            descTextView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    static func makeSectionLabel(_ name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupBindings() {
        viewModel.isValid.bind({ [weak self] isValid in
            self?.navigationItem.rightBarButtonItem?.isEnabled = isValid
        })
    }
}

// MARK: - Actions & Keyboard
private extension AddMovieViewController {
    
    func setupKeyboardHiding() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        // Prevents touch delays on other components (buttons won't hang on the first tap)
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupFieldActions() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        yearTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        ratingTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)    }
}

// MARK: - @objc methods
private extension AddMovieViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  // Closes the keyboard across the entire view hierarchy
    }
    
    @objc func cancelAddingMovie() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        viewModel.title = nameTextField.text
        viewModel.year = yearTextField.text
        viewModel.rating = ratingTextField.text
        
        viewModel.validateForm()
    }
    
    @objc func saveNewMovie() {
        viewModel.description = descTextView.text
        
        viewModel.saveMovie()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Custom UI Components
class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 15)
    
    init(placeholder: String, keyboardType: UIKeyboardType) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.textColor = .label
        self.textAlignment = .left
        self.borderStyle = .none
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.keyboardType = keyboardType
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

// MARK: - Validation & Parsing
private extension AddMovieViewController {
    
    
    
}
