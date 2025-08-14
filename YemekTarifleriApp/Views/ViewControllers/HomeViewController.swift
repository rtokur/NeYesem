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
    private var suggestions: [String] = []
    private var categories: [String: String] = ["Kahvaltı": "breakfast",
                                                "Ana Yemek": "meal",
                                                "Tatlı": "dessert",
                                                "Salata": "salad",
                                                "Yan Yemek": "",
                                                "Meze": "",
                                                "Ekmek": "",
                                                "Çorba": "",
                                                "İçecek": "",
                                                "Sos": "",
                                                "Marine": "",
                                                "Parmak Yiyecek": "",
                                                "Atıştırmalık": ""]
    
    //MARK: UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    private lazy var helloStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Merhaba"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private lazy var cookLabel: UILabel = {
        let label = UILabel()
        label.text = "Bugün ne pişireceksin?"
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
            .font: UIFont.dmSansRegular(14, weight: .thin)
        ]
        textField.tintColor = UIColor.textColor300
        textField.attributedPlaceholder = NSAttributedString(string: "Tarif ara", attributes: attributes)
        textField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Popüler Kategoriler"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        return label
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
        collectionView.register(HomeMealTypeCollectionViewCell.self, forCellWithReuseIdentifier: HomeMealTypeCollectionViewCell.reuseID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 15,
                                                   bottom: 0,
                                                   right: 15)
        return collectionView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Senin için önerilenler"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tümünü gör",
                        for: .normal)
        button.titleLabel?.font = .dmSansSemiBold(12)
        button.tintColor = .secondaryColor
        return button
    }()
    
    private lazy var suggestionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 153, height: 216)
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
    
    private lazy var hStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var lastViewedLabel: UILabel = {
        let label = UILabel()
        label.text = "En son görüntülenenler"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private lazy var seeAllButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tümünü gör",
                        for: .normal)
        button.titleLabel?.font = .dmSansSemiBold(12)
        button.tintColor = .secondaryColor
        return button
    }()
    
    private let suggestionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.isHidden = true
        stack.backgroundColor = .white
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        viewModel.diet = "vegetarian"
        viewModel.intolerances = ["gluten", "dairy"]
        viewModel.excludeIngredients = ["peanut"]
        fetchInitialData()
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
        stackView.addArrangedSubview(popularLabel)
        stackView.setCustomSpacing(10, after: popularLabel)
        stackView.addArrangedSubview(popularCollectionView)
        stackView.addArrangedSubview(hStackView)
        hStackView.addArrangedSubview(suggestionLabel)
        hStackView.addArrangedSubview(seeAllButton)
        stackView.addArrangedSubview(suggestionCollectionView)
        stackView.setCustomSpacing(10, after: hStackView)
        stackView.addArrangedSubview(hStackView2)
        hStackView2.addArrangedSubview(lastViewedLabel)
        hStackView2.addArrangedSubview(seeAllButton2)
        view.addSubview(suggestionStackView)
        self.hideKeyboardOnTap()
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
        popularLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        popularCollectionView.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.width.equalToSuperview()
        }
        hStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        seeAllButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        suggestionCollectionView.snp.makeConstraints { make in
            make.height.equalTo(216)
            make.width.equalToSuperview()
        }
        hStackView2.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        seeAllButton2.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        suggestionStackView.snp.makeConstraints { make in
            make.top.equalTo(customSearchBarView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    //MARK: - Functions
    private func updateSuggestions() {
        suggestionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !viewModel.recipes.isEmpty else {
            suggestionStackView.isHidden = true
            return
        }
        
        suggestionStackView.isHidden = false
        
        for recipe in viewModel.recipes {
            let label = UILabel()
            label.text = recipe.title
            label.font = .systemFont(ofSize: 14)
            label.textColor = .darkGray
            label.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(suggestionTapped(_:)))
            label.addGestureRecognizer(tap)
            
            suggestionStackView.addArrangedSubview(label)
        }
    }
    
    private func fetchInitialData() {
        viewModel.fetchRecommendedRecipes { [weak self] in
            DispatchQueue.main.async {
                self?.suggestionCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - Actions
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let query = textField.text, query.count >= 2 else {
            suggestionStackView.isHidden = true
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch(_:)), object: nil)
        perform(#selector(performSearch(_:)), with: query, afterDelay: 0.5)
    }
    
    @objc private func performSearch(_ query: String) {
        viewModel.fetchRecommendedRecipes(query: query) { [weak self] in
            DispatchQueue.main.async {
                self?.updateSuggestions()
            }
        }
    }
    
    @objc private func suggestionTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        searchTextField.text = label.text
        suggestionStackView.isHidden = true
        
        print("Selected recipe:", label.text ?? "")
    }
    
    @objc func navigateToNotification() {
        let notificationsViewController = NotificationsViewController()
        navigationController?.pushViewController(notificationsViewController,
                                                 animated: true)
    }
}

extension HomeViewController: UITextFieldDelegate,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularCollectionView {
            return categories.count
        }
        return viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMealTypeCollectionViewCell.reuseID, for: indexPath) as! HomeMealTypeCollectionViewCell
            let categoryName = Array(categories.keys)[indexPath.row]
            let categoryImage = categories[categoryName]
            cell.configure(mealPhotoName: categoryImage ?? "",
                           mealName: categoryName)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMealCollectionViewCell.reuseID, for: indexPath) as! FavoriteMealCollectionViewCell
        let recipe = viewModel.recipes[indexPath.row]
        cell.configure(mealType: recipe.dishTypes?[0] ?? "",
                       mealName: recipe.title,
                       mealImageUrl: recipe.image,
                       mealTime: "\(recipe.readyInMinutes ?? 0) dk.")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == suggestionCollectionView {
            let selectedRecipe = viewModel.recipes[indexPath.item]
            let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.id)
            let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
            navigationController?.pushViewController(detailViewController,
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
        suggestionStackView.isHidden = true
    }
}
