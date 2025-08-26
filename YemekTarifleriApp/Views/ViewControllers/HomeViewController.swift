//
//  HomeViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class HomeViewController: UIViewController{
    
    //MARK: - Properties
    private let viewModel = HomeViewModel()
    private var selectedSuggestionIndex: Int?
    
    //MARK: UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var helloStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private lazy var cookLabel: UILabel = {
        let label = UILabel()
        label.text = "What will you cook today?"
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text600
        return label
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "bell")
        configuration.background.cornerRadius = 10
        configuration.baseBackgroundColor = .white
        button.configuration = configuration
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.07
        button.layer.masksToBounds = false
        button.addTarget(self,
                         action: #selector(navigateToNotification),
                         for: .touchUpInside)
        return button
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
        textField.tintColor = UIColor.textColor300
        textField.attributedPlaceholder = NSAttributedString(string: "Search Recipes",
                                                             attributes: attributes)
        textField.addTarget(self,
                            action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    private lazy var hStackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Categories"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private lazy var seeAllButton3: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All",
                        for: .normal)
        button.titleLabel?.font = .dmSansSemiBold(12)
        button.tintColor = .secondaryColor
        button.addTarget(self,
                         action: #selector(navigateToCategories),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80,
                                 height: 105)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeMealTypeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeMealTypeCollectionViewCell.reuseID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 15,
                                                   bottom: 0,
                                                   right: 15)
        return collectionView
    }()
    
    private lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Recommended for You"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private lazy var suggestionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 153,
                                 height: 212)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteMealCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteMealCollectionViewCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 15,
                                                   bottom: 0,
                                                   right: 15)
        return collectionView
    }()
    
    private lazy var lastViewedLabel: UILabel = {
        let label = UILabel()
        label.text = "Recently Viewed"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private lazy var lastViewedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 153,
                                 height: 212)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteMealCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoriteMealCollectionViewCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 15,
                                                   bottom: 0,
                                                   right: 15)
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupDismissKeyboardTap()
        bindViewModel()
        fetchInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSuggestionHighlights()
        fetchInitialData()
    }
    
    // MARK: - Data
    private func fetchInitialData() {
        viewModel.fetchRecommendedRecipes()
        viewModel.fetchRecentViewed()
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onRecommendedUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.suggestionCollectionView.reloadData()
            }
        }
        viewModel.onRecentViewedUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.lastViewedCollectionView.reloadData()
            }
        }
        viewModel.onError = { errorMessage in
            print("Hata: \(errorMessage)")
        }
        viewModel.onSearchSuggestionsUpdated = { [weak self] in
            self?.updateSuggestions()
        }
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(helloStackView)
        helloStackView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(helloLabel)
        titleStackView.addArrangedSubview(cookLabel)
        helloStackView.addArrangedSubview(notificationButton)
        stackView.addArrangedSubview(customSearchBarView)
        customSearchBarView.addSubview(searchBarStackView)
        searchBarStackView.addArrangedSubview(iconImageView)
        searchBarStackView.addArrangedSubview(searchTextField)
        searchTextField.delegate = self
        stackView.addArrangedSubview(hStackView3)
        hStackView3.addArrangedSubview(popularLabel)
        hStackView3.addArrangedSubview(seeAllButton3)
        stackView.setCustomSpacing(10, after: hStackView3)
        stackView.addArrangedSubview(popularCollectionView)
        stackView.addArrangedSubview(suggestionLabel)
        stackView.addArrangedSubview(suggestionCollectionView)
        stackView.setCustomSpacing(10, after: suggestionLabel)
        stackView.addArrangedSubview(lastViewedLabel)
        stackView.addArrangedSubview(lastViewedCollectionView)
        stackView.setCustomSpacing(10, after: lastViewedLabel)
        view.addSubview(suggestionView)
        suggestionView.addSubview(suggestionStackView)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        helloStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
        titleStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        notificationButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
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
        hStackView3.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        seeAllButton3.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        popularCollectionView.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.width.equalToSuperview()
        }
        suggestionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        suggestionCollectionView.snp.makeConstraints { make in
            make.height.equalTo(216)
            make.width.equalToSuperview()
        }
        lastViewedLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        lastViewedCollectionView.snp.makeConstraints { make in
            make.height.equalTo(216)
            make.width.equalToSuperview()
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
    
    //MARK: - Functions
    private func updateSuggestions() {
        suggestionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !viewModel.searchSuggestions.isEmpty else {
            suggestionView.isHidden = true
            return
        }
        suggestionView.isHidden = false
        
        for (index, recipe) in viewModel.searchSuggestions.enumerated() {
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(suggestionTapped(_:)))
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
        let recipe = viewModel.searchSuggestions[index].recipe
        let recipeDetailViewModel = RecipeDetailViewModel(recipeId: recipe.id)
        let mealDetailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
        mealDetailViewController.hidesBottomBarWhenPushed = true
        mealDetailViewController.source = .home
        navigationController?.pushViewController(mealDetailViewController,
                                                 animated: true)
    }
    
    @objc func navigateToNotification() {
        let notificationsViewController = NotificationsViewController()
        notificationsViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notificationsViewController,
                                                 animated: true)
    }
    
    @objc func navigateToCategories() {
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(categoriesViewController,
                                                 animated: true)
    }
}

// MARK: - Delegate And Data Sources
extension HomeViewController: UITextFieldDelegate,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularCollectionView {
            return viewModel.categories.count
        } else if collectionView == lastViewedCollectionView {
            return viewModel.recentViewedRecipes.count
        }
        return viewModel.recommendedRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMealTypeCollectionViewCell.reuseID,
                                                          for: indexPath) as! HomeMealTypeCollectionViewCell
            let categoryName = viewModel.categories[indexPath.row].title
            let categoryImage = viewModel.categories[indexPath.row].type
            cell.configure(mealPhotoName: categoryImage,
                           mealName: categoryName)
            return cell
        } else if collectionView == lastViewedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMealCollectionViewCell.reuseID,
                                                          for: indexPath) as! FavoriteMealCollectionViewCell
            let uiModel = viewModel.recentViewedRecipes[indexPath.row]
            cell.configure(model: uiModel)
            cell.onFavoriteButtonTapped = { [weak self] in
                self?.viewModel.toggleFavorite(in: .recent, at: indexPath.item) { success in
                    if success {
                        DispatchQueue.main.async {
                            collectionView.reloadItems(at: [indexPath])
                            self?.suggestionCollectionView.reloadData()
                        }
                    }
                }
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMealCollectionViewCell.reuseID,
                                                      for: indexPath) as! FavoriteMealCollectionViewCell
        let uiModel = viewModel.recommendedRecipes[indexPath.row]
        cell.configure(model: uiModel)
        
        cell.onFavoriteButtonTapped = { [weak self] in
            self?.viewModel.toggleFavorite(in: .recommended,
                                           at: indexPath.item) { success in
                if success {
                    DispatchQueue.main.async {
                        collectionView.reloadItems(at: [indexPath])
                        self?.lastViewedCollectionView.reloadData()
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == suggestionCollectionView {
            let selectedRecipe = viewModel.recommendedRecipes[indexPath.item].recipe
            let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.id)
            let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
            detailViewController.hidesBottomBarWhenPushed = true
            detailViewController.source = .home
            navigationController?.pushViewController(detailViewController,
                                                     animated: true)
        } else if collectionView == lastViewedCollectionView {
            let selectedRecipe = viewModel.recentViewedRecipes[indexPath.item].recipe
            let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.id)
            let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
            detailViewController.hidesBottomBarWhenPushed = true
            detailViewController.source = .home
            navigationController?.pushViewController(detailViewController,
                                                     animated: true)
        } else {
            let categoryViewController = CategoryViewController()
            let category = viewModel.categories[indexPath.row]
            categoryViewController.selectedCategory = category.title
            categoryViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(categoryViewController,
                                                     animated: true)
        }
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
