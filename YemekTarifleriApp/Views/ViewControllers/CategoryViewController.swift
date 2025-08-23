//
//  CategoryViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 20.08.2025.
//

import UIKit

class CategoryViewController: UIViewController {
    //MARK: - Properties
    var selectedCategory: String?
    private var selectedSuggestionIndex: Int?
    private let viewModel = CategoryViewModel()
    
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
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
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
        textField.attributedPlaceholder = NSAttributedString(string: "Search Recipes",
                                                             attributes: attributes)
        textField.delegate = self
        textField.addTarget(self,
                            action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "sort")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        button.configuration = configuration
        button.tintColor = UIColor.textColor500
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "slider.horizontal.3")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        button.configuration = configuration
        button.tintColor = UIColor.textColor500
        return button
    }()
    
    private lazy var mealCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 14
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FavoriteMealCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoriteMealCollectionViewCell.reuseID)
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
        bindViewModel()
        setupDismissKeyboardTap()
        fetchInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSuggestionHighlights()
        fetchInitialData()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        view.addSubview(backButton)
        stackView.addArrangedSubview(searchStackView)
        searchStackView.addArrangedSubview(customSearchBarView)
        customSearchBarView.addSubview(searchBarStackView)
        searchBarStackView.addArrangedSubview(iconImageView)
        searchBarStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(sortButton)
        searchStackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(mealCollectionView)
        view.addSubview(suggestionView)
        suggestionView.addSubview(suggestionStackView)
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(15)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        searchStackView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        customSearchBarView.snp.makeConstraints { make in
            make.height.equalToSuperview()
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
        sortButton.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        filterButton.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        mealCollectionView.snp.makeConstraints { make in
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
    
    // MARK: - Data
    private func fetchInitialData() {
        if let category = selectedCategory {
            titleLabel.text = category
            viewModel.fetchRecipes(for: category)
        }
    }
    
    
    private func bindViewModel() {
        viewModel.onRecipesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.mealCollectionView.reloadData()
            }
        }
        viewModel.onSearchSuggestionsUpdated = { [weak self] in
            self?.updateSuggestions()
        }
    }
    
    //MARK: - Functions
    private func updateSuggestions() {
        suggestionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !viewModel.searchSuggestionsRecipes.isEmpty else {
            suggestionView.isHidden = true
            return
        }
        suggestionView.isHidden = false
        
        for (index, recipe) in viewModel.searchSuggestionsRecipes.enumerated() {
            let container = UIView()
            container.tag = index
            container.layer.cornerRadius = 8
            container.layer.masksToBounds = true
            container.backgroundColor = (index == selectedSuggestionIndex) ? UIColor.Text50 : .white
            
            let label = UILabel()
            label.text = recipe.recipe.title
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
    
    private func resetSuggestionHighlights() {
        suggestionStackView.arrangedSubviews.forEach { row in
            row.backgroundColor = .white
        }
        selectedSuggestionIndex = nil
    }
    
    private func setupDismissKeyboardTap() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboardAndHideSuggestions))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Actions
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
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
        viewModel.fetchAutocompleteRecipes(query: query)
    }
    
    @objc private func dismissKeyboardAndHideSuggestions() {
        view.endEditing(true)
        resetSuggestionHighlights()
    }
    
    @objc private func suggestionTapped(_ gesture: UITapGestureRecognizer) {
        guard let container = gesture.view else { return }
        selectedSuggestionIndex = container.tag
        
        resetSuggestionHighlights()
        container.backgroundColor = UIColor.Text50
        
        let index = container.tag
        let recipe = viewModel.searchSuggestionsRecipes[index].recipe
        let recipeDetailViewModel = RecipeDetailViewModel(recipeId: recipe.id)
        let mealDetailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
        mealDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(mealDetailViewController,
                                                 animated: true)
    }
}

//MARK: - Delegates
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteMealCollectionViewCell.reuseID,
            for: indexPath
        ) as! FavoriteMealCollectionViewCell
        
        if let recipe = viewModel.item(at: indexPath.row) {
            cell.configure(model: recipe)
        }
        cell.onFavoriteButtonTapped = { [weak self] in
            self?.viewModel.toggleFavorite(at: indexPath.item) { success in
                if success {
                    DispatchQueue.main.async {
                        collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedRecipe = viewModel.item(at: indexPath.row) else { return }
        let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.recipe.id)
        let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController,
                                                 animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 2) - 7
        return CGSize(width: width, height: 212)
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
