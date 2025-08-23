//
//  CategoriesViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 20.08.2025.
//

import UIKit

class CategoriesViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = CategoryViewModel()
    private var selectedSuggestionIndex: Int?
    
    //MARK: UI Elements
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        button.addTarget(self,
                         action: #selector(backButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()
    
    private let customSearchBarView: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.layer.cornerRadius = 10
        container.layer.borderColor = UIColor.Text200.cgColor
        container.layer.borderWidth = 1
        return container
    }()
    
    private let searchBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = UIColor.textColor300
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.textColor900
        textField.font = UIFont.dmSansRegular(14)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textColor300,
            .font: UIFont.dmSansRegular(14, weight: .thin)
        ]
        textField.tintColor = UIColor.textColor300
        textField.attributedPlaceholder = NSAttributedString(string: "Search Categories",
                                                             attributes: attributes)
        textField.addTarget(self,
                            action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self,
                    forCellWithReuseIdentifier: CategoryCell.reuseID)
        return collectionView
    }()
    
    private let suggestionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0,
                                         height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.isHidden = true
        return view
    }()
    
    private let suggestionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        viewModel.onSuggestionsUpdated = { [weak self] _ in
            self?.updateSuggestions()
        }
        collectionView.reloadData()
        setupDismissKeyboardTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSuggestionHighlights()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        view.addSubview(backButton)
        stackView.addArrangedSubview(customSearchBarView)
        customSearchBarView.addSubview(searchBarStackView)
        searchBarStackView.addArrangedSubview(iconImageView)
        searchBarStackView.addArrangedSubview(searchTextField)
        searchTextField.delegate = self
        stackView.addArrangedSubview(collectionView)
        view.addSubview(suggestionView)
        suggestionView.addSubview(suggestionStackView)
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        customSearchBarView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        searchBarStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        searchTextField.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        suggestionView.snp.makeConstraints { make in
            make.top.equalTo(customSearchBarView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        suggestionStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Update Suggestions
    private func updateSuggestions() {
        suggestionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !viewModel.searchSuggestions.isEmpty else {
            suggestionView.isHidden = true
            return
        }
        suggestionView.isHidden = false
        
        for (index, category) in viewModel.searchSuggestions.enumerated() {
            let container = UIView()
            container.tag = index
            container.layer.cornerRadius = 8
            container.layer.masksToBounds = true
            container.backgroundColor = (index == selectedSuggestionIndex) ? UIColor.Text50 : .white
            
            let label = UILabel()
            label.text = category.title
            label.font = .dmSansRegular(14)
            label.textColor = UIColor.textColor900
            label.isUserInteractionEnabled = false
            
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(suggestionTapped(_:)))
            container.addGestureRecognizer(tap)
            
            suggestionStackView.addArrangedSubview(container)
            container.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(15)
            }
        }
    }
    
    // MARK: - Reset Suggestion Highlights
    private func resetSuggestionHighlights() {
        suggestionStackView.arrangedSubviews.forEach { row in
            row.backgroundColor = .white
        }
        selectedSuggestionIndex = nil
    }
    
    
    // MARK: - Dismiss Keyboard
    private func setupDismissKeyboardTap() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboardAndHideSuggestions))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Actions
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let query = textField.text, query.count >= 2 else {
            suggestionView.isHidden = true
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(performSearch(_:)),
                                               object: nil)
        perform(#selector(performSearch(_:)), with: query, afterDelay: 0.5)
    }
    
    
    @objc private func performSearch(_ query: String) {
        viewModel.fetchAutocompleteSuggestions(query: query)
    }
    
    @objc private func dismissKeyboardAndHideSuggestions() {
        view.endEditing(true)
        suggestionView.isHidden = true
        resetSuggestionHighlights()
    }
    
    @objc private func suggestionTapped(_ gesture: UITapGestureRecognizer) {
        guard let container = gesture.view else { return }
        selectedSuggestionIndex = container.tag
        
        resetSuggestionHighlights()
        container.backgroundColor = UIColor.Text50
        
        let index = container.tag
        let category = viewModel.searchSuggestions[index].title
        let categoryViewController = CategoryViewController()
        categoryViewController.selectedCategory = category
        navigationController?.pushViewController(categoryViewController,
                                                 animated: true)
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Delegate and Data Source
extension CategoriesViewController: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        let category = viewModel.allCategories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.allCategories[indexPath.item].title
        let categoryViewController = CategoryViewController()
        categoryViewController.selectedCategory = category
        navigationController?.pushViewController(categoryViewController,
                                                 animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 3) - 7
        return CGSize(width: width, height: 160)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        customSearchBarView.layer.borderColor = UIColor.primaryColor.cgColor
        iconImageView.tintColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        customSearchBarView.layer.borderColor = UIColor.textColor300.cgColor
        iconImageView.tintColor = UIColor.textColor300
        suggestionView.isHidden = true
    }
}
