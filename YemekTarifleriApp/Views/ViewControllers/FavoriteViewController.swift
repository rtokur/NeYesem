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
    private let categories = ["Tüm tarifler",
                              "Ana Yemek",
                              "Yan Yemek",
                              "Tatlı",
                              "Meze",
                              "Salata",
                              "Ekmek",
                              "Kahvaltılık",
                              "Çorba",
                              "İçecek",
                              "Sos",
                              "Marine",
                              "Parmak Yiyecek",
                              "Atıştırmalık",
                              "İçecek"]
    private var filteredFavorites: [Recipe] = []
    private var selectedIndexPath: IndexPath = IndexPath(item: 0,
                                                         section: 0)
    
    //MARK: UI Elements
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    private lazy var favoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorilerim"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
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
        textField.addTarget(self,
                            action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
        textField.tintColor = UIColor.textColor300
        textField.attributedPlaceholder = NSAttributedString(string: "Tarif ara", attributes: attributes)
        return textField
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
    
    private lazy var mealTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(MealTypeCollectionViewCell.self, forCellWithReuseIdentifier: MealTypeCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 15,
                                                   bottom: 0,
                                                   right: 15)
        return collectionView
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
        collectionView.register(FavoriteMealCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteMealCollectionViewCell.reuseID)
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
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        preselectFirstCategory()
        viewModel.onFavoritesUpdated = { [weak self] in
            self?.mealCollectionView.reloadData()
        }
        viewModel.fetchFavorites()
        setupDismissKeyboardTap()
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
        searchStackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(mealTypeCollectionView)
        stackView.addArrangedSubview(mealCollectionView)
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
        filterButton.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        mealTypeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalToSuperview()
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
    
    private func setupDismissKeyboardTap() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboardAndHideSuggestions))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func preselectFirstCategory() {
        DispatchQueue.main.async {
            self.mealTypeCollectionView.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: [])
        }
    }
    
    private func updateSearchSuggestions() {
        suggestionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard filteredFavorites.count > 0 else {
            suggestionView.isHidden = true
            return
        }
        
        suggestionView.isHidden = false
        for recipe in filteredFavorites {
            let label = UILabel()
            label.text = recipe.title
            label.font = UIFont.dmSansRegular(14)
            label.textColor = UIColor.textColor900
            label.isUserInteractionEnabled = true
            label.tag = recipe.id
            let tap = UITapGestureRecognizer(target: self, action: #selector(suggestionTapped(_:)))
            label.addGestureRecognizer(tap)
            suggestionStackView.addArrangedSubview(label)
        }
    }

    //MARK: - Actions
    @objc private func suggestionTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        guard let selectedRecipe = viewModel.favorites.first(where: { $0.id == label.tag }) else { return }
        
        let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.id)
        let detailVC = MealDetailViewController(viewModel: recipeDetailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
        
        searchTextField.text = ""
        filteredFavorites.removeAll()
        suggestionView.isHidden = true
    }
    
    @objc private func dismissKeyboardAndHideSuggestions() {
        view.endEditing(true)
        suggestionView.isHidden = true
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let text = textField.text, text.count >= 2 else {
            filteredFavorites.removeAll()
            suggestionView.isHidden = true
            updateSearchSuggestions()
            return
        }
        
        filteredFavorites = viewModel.favorites.filter { $0.title.lowercased().contains(text.lowercased()) }
        updateSearchSuggestions()
    }

}

//MARK: - Delegates
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealCollectionView {
            return viewModel.numberOfItems()
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mealCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMealCollectionViewCell.reuseID, for: indexPath) as! FavoriteMealCollectionViewCell
            guard let meal = viewModel.item(at: indexPath.row) else { return cell}
            viewModel.getLikeCount(recipeId: meal.id) { count in
                DispatchQueue.main.async {
                    cell.configure(
                        mealType: meal.dishTypes?[0] ?? "",
                        mealName: meal.title,
                        mealImageUrl: meal.image ?? "",
                        mealTime: "\(meal.readyInMinutes ?? 0) dk.",
                        isFavorited: true,
                        likeCount: count
                    )
                }
            }
            cell.onFavoriteButtonTapped = { [weak self] in
                guard let self = self, let meal = self.viewModel.item(at: indexPath.row) else { return }
                self.viewModel.toggleFavorite(recipe: meal)
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MealTypeCollectionViewCell.reuseID,
            for: indexPath
        ) as! MealTypeCollectionViewCell
        cell.configure(title: categories[indexPath.item])
        cell.isSelected = (indexPath == selectedIndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealCollectionView {
            guard let selectedRecipe = viewModel.item(at: indexPath.row) else { return }
            let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.id)
            let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
            navigationController?.pushViewController(detailViewController,
                                                     animated: true)
        } else {
            if selectedIndexPath != indexPath {
                if let oldCell = collectionView.cellForItem(at: selectedIndexPath) as? MealTypeCollectionViewCell {
                    oldCell.isSelected = false
                }
                selectedIndexPath = indexPath
            }
            
            if let newCell = collectionView.cellForItem(at: indexPath) as? MealTypeCollectionViewCell {
                newCell.isSelected = true
            }
            
            print("Seçilen kategori: \(categories[indexPath.item])")
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mealCollectionView {
            let width = (collectionView.bounds.width / 2) - 7
            return CGSize(width: width, height: 212)
        }
        let text = categories[indexPath.item] as NSString
        let font = UIFont.dmSansSemiBold(11)
        let textSize = text.size(withAttributes: [.font: font])
        let horizontalPadding: CGFloat = 20
        let height: CGFloat = 36
        return CGSize(width: ceil(textSize.width) + horizontalPadding, height: height)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customSearchBarView.layer.borderColor = UIColor.primaryColor.cgColor
        iconImageView.tintColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        customSearchBarView.layer.borderColor = UIColor.textColor300.cgColor
        iconImageView.tintColor = UIColor.textColor300
    }
}
