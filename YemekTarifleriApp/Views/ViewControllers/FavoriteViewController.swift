//
//  FavoriteViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 1.08.2025.
//

import UIKit
import FirebaseAuth

class FavoriteViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    private let viewModel = FavoriteViewModel()
    private let categories = ["All recipes",
                              "Main Course",
                              "Side Dish",
                              "Dessert",
                              "Appetizer",
                              "Salad",
                              "Bread",
                              "Breakfast",
                              "Soup",
                              "Beverage",
                              "Sauce",
                              "Marinade",
                              "Finger Food",
                              "Snack",
                              "Drink"]
    private var filteredFavorites: [RecipeUIModel] = []
    private var selectedIndexPath: IndexPath = IndexPath(item: 0,
                                                         section: 0)
    
    //MARK: UI Elements
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var favoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "My Favorites"
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
            .font: UIFont.dmSansRegular(14,
                                        weight: .thin)
        ]
        textField.addTarget(self,
                            action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
        textField.tintColor = UIColor.textColor300
        textField.attributedPlaceholder = NSAttributedString(string: "Search Recipes",
                                                             attributes: attributes)
        return textField
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "sort")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        button.configuration = configuration
        button.tintColor = UIColor.textColor500
        button.addTarget(self,
                         action: #selector(sortButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "slider.horizontal.3")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        button.configuration = configuration
        button.tintColor = UIColor.textColor500
        button.addTarget(self,
                         action: #selector(filterButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var mealCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 14
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FavoriteMealCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoriteMealCollectionViewCell.reuseID)
        return collectionView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nofavorite")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven’t added any recipes to your favorites yet"
        label.font = .dmSansBold(18)
        label.textColor = UIColor.Text600
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Start exploring now and save the recipes you love! 🔖"
        label.font = .dmSansRegular(16)
        label.textColor = UIColor.textColor400
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
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
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(favoritesLabel)
        stackView.addArrangedSubview(searchStackView)
        searchStackView.addArrangedSubview(customSearchBarView)
        customSearchBarView.addSubview(searchBarStackView)
        searchBarStackView.addArrangedSubview(iconImageView)
        searchBarStackView.addArrangedSubview(searchTextField)
        searchTextField.delegate = self
        searchStackView.addArrangedSubview(sortButton)
        searchStackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(mealCollectionView)
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
        view.addSubview(suggestionView)
        suggestionView.addSubview(suggestionStackView)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        favoritesLabel.snp.makeConstraints { make in
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
        emptyStateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(mealCollectionView.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
            make.width.height.equalTo(180)
        }
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        emptySubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
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
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onFavoritesUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let selectedCategory = self.categories[self.selectedIndexPath.item]
                self.filteredFavorites = self.viewModel.favorites
                self.mealCollectionView.reloadData()
                self.updateEmptyState()
            }
        }
        viewModel.fetchFavorites()
    }
    
    // MARK: - Update Suggestions
    private func updateSearchSuggestions() {
        suggestionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard filteredFavorites.count > 0 else {
            suggestionView.isHidden = true
            return
        }
        
        suggestionView.isHidden = false
        for recipe in filteredFavorites {
            let label = UILabel()
            label.text = recipe.recipe.title
            label.font = UIFont.dmSansRegular(14)
            label.textColor = UIColor.textColor900
            label.isUserInteractionEnabled = true
            label.tag = recipe.recipe.id
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(suggestionTapped(_:)))
            label.addGestureRecognizer(tap)
            suggestionStackView.addArrangedSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(15)
            }
        }
    }

    private func updateEmptyState() {
        let isEmpty = viewModel.numberOfItems() == 0
        emptyStateView.isHidden = !isEmpty
    }

    //MARK: - Actions
    @objc private func suggestionTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        guard let selectedRecipe = viewModel.favorites.first(where: { $0.recipe.id == label.tag }) else { return }
        
        let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.recipe.id)
        let detailVC = MealDetailViewController(viewModel: recipeDetailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
        
        searchTextField.text = ""
        filteredFavorites.removeAll()
        suggestionView.isHidden = true
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let text = textField.text, text.count >= 2 else {
            filteredFavorites.removeAll()
            suggestionView.isHidden = true
            updateSearchSuggestions()
            return
        }
        
        filteredFavorites = viewModel.favorites.filter { $0.recipe.title.lowercased().contains(text.lowercased()) }
        updateSearchSuggestions()
    }
    
    @objc private func sortButtonTapped() {
        let sortViewController = SortViewController()
        sortViewController.sheetPresentationController?.detents = [.custom(resolver: { context in
            return context.maximumDetentValue * 0.45
        })]
        sortViewController.sheetPresentationController?.preferredCornerRadius = 20
        sortViewController.sheetPresentationController?.prefersGrabberVisible = true
        sortViewController.onSelection = { [weak self] selectedOption in
            guard let self = self else { return }
            print("Seçilen sıralama: \(selectedOption)")
            
            self.viewModel.sortFavorites(by: selectedOption)
        }
        present(sortViewController, animated: true)
    }
    
    @objc private func filterButtonTapped() {
        let filterViewController = FilterViewController()
        filterViewController.sheetPresentationController?.detents = [.custom(resolver: { context in
            return context.maximumDetentValue * 0.55
        })]
        filterViewController.sheetPresentationController?.preferredCornerRadius = 20
        filterViewController.sheetPresentationController?.prefersGrabberVisible = true
        filterViewController.onApply = { [weak self] selectedCategories in
            guard let self = self else { return }
            self.filteredFavorites = self.viewModel.filterFavorites(by: Array(selectedCategories))
            self.mealCollectionView.reloadData()
        }
        present(filterViewController, animated: true)
    }
}

//MARK: - Delegates
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteMealCollectionViewCell.reuseID,
            for: indexPath
        ) as! FavoriteMealCollectionViewCell
        
        let uiModel = filteredFavorites[indexPath.row]
        cell.configure(model: uiModel)
        cell.onFavoriteButtonTapped = { [weak self] in
            self?.viewModel.toggleFavorite(recipe: uiModel.recipe)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedRecipe = viewModel.item(at: indexPath.row) else { return }
        let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.recipe.id)
        let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
        detailViewController.hidesBottomBarWhenPushed = true
        detailViewController.source = .favorite
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
