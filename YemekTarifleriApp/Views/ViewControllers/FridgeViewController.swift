//
//  FridgeViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class FridgeViewController: UIViewController {
    //MARK: - Properties
    let viewModel = FridgeViewModel()
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Fridge"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "List the ingredients in your fridge, and we’ll suggest personalized recipes!"
        label.font = .dmSansRegular(14, weight: .thin)
        label.textColor = UIColor.Text600
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let categoryBar = CategoryBarView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FridgeCollectionViewCell.self,
                                forCellWithReuseIdentifier: FridgeCollectionViewCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var addIngredientButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor.primaryColor
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        
        let titleFont = UIFont.dmSansBold(16)
        let titleAttr = AttributedString("Add New Ingredient",
                                         attributes: AttributeContainer([
                                            .font: titleFont
                                         ]))
        configuration.attributedTitle = titleAttr
        
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 10,
                                                            weight: .bold)
        configuration.image = UIImage(systemName: "plus",
                                      withConfiguration: iconConfiguration)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 5
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.addTarget(self,
                         action: #selector(addIngredientsButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "With these ingredients, you can make the following recipes"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var cookLabel: UILabel = {
        let label = UILabel()
        label.text = "What will you cook today?"
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text600
        label.textAlignment = .left
        return label
    }()
    
    private lazy var recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RecipeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecipeCollectionViewCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.fetchFridgeItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFridgeItems()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(categoryBar)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(addIngredientButton)
        stackView.addArrangedSubview(label)
        stackView.setCustomSpacing(5, after: label)
        stackView.addArrangedSubview(cookLabel)
        stackView.addArrangedSubview(recipesCollectionView)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        categoryBar.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
        }
        addIngredientButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        cookLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        recipesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onFridgeUpdated = { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.snp.updateConstraints { make in
                make.height.equalTo(self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 1)
            }
            self?.viewModel.fetchRecipesFromFridge()
        }
        
        viewModel.onError = { error in
            print("Fridge fetch error:", error)
        }
        viewModel.onRecipesUpdated = { [weak self] in
            self?.recipesCollectionView.reloadData()
            self?.recipesCollectionView.snp.updateConstraints { make in
                make.height.equalTo(self?.recipesCollectionView.collectionViewLayout.collectionViewContentSize.height ?? 1)
            }
        }
        categoryBar.categories = viewModel.allAisles
        categoryBar.onSelectionChanged = { [weak self] aisle, index in
            self?.viewModel.selectAisle(aisle)
        }
    }
    
    // MARK: - Actions
    @objc func addIngredientsButtonAction(){
        let addIngredientsViewController = AddIngredientsViewController()
        addIngredientsViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addIngredientsViewController, animated: true)
    }
}

// MARK: - Delegates and Data Source
extension FridgeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.filteredItems.count
        } else {
            return viewModel.recommendedRecipes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FridgeCollectionViewCell.reuseID,
                                                          for: indexPath) as! FridgeCollectionViewCell
            let item = viewModel.filteredItems[indexPath.row]
            cell.configure(with: item)
            cell.onAmountChanged = { [weak self] newAmount in
                var updated = item
                updated.amount = Double(newAmount)
                self?.viewModel.updateFridgeItem(updated)
            }
            cell.didTapDelete = { [weak self] in
                guard let self,
                      indexPath.item < self.viewModel.filteredItems.count else { return }
                
                let item = self.viewModel.filteredItems[indexPath.item]
                let alert = CustomAlertView(titleText: "Are you sure you want to delete this item?",
                                            confirmText: "Yes",
                                            cancelText: "No",
                                            isConfirmHidden: false)
                
                alert.onConfirm = { [weak self] in
                    self?.viewModel.deleteFridgeItem(item) { _ in
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    }
                }
                alert.present(on: self)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.reuseID,
                                                          for: indexPath) as! RecipeCollectionViewCell
            let recipe = viewModel.recommendedRecipes[indexPath.item]
            cell.configure(recipe: recipe)
            cell.likeButtonAction = { [weak self] in
                guard let self else { return }
                self.viewModel.toggleFavorite(in: indexPath.item) { success in
                    if success {
                        DispatchQueue.main.async {
                            collectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
            cell.goButtonAction = { [weak self] in
                guard let self = self else { return }
                let selectedRecipe = self.viewModel.recommendedRecipes[indexPath.item].recipe
                let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.id)
                let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
                detailViewController.hidesBottomBarWhenPushed = true
                detailViewController.source = .fridge
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let ingredient = viewModel.filteredItems[indexPath.item]
            let font = UIFont.dmSansRegular(12)
            let text = ingredient.name as NSString
            let textSize = text.size(withAttributes: [.font: font])
            let amountText = "\(Int(ingredient.amount ?? 0.0)) \(ingredient.unit ?? "")" as NSString
            let textSize2 = amountText.size(withAttributes: [.font: font])
            return CGSize(width: ceil(textSize.width + textSize2.width) + 85,
                          height: 40)
        } else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recipesCollectionView {
            let selectedRecipe = viewModel.recommendedRecipes[indexPath.item].recipe
            let recipeDetailViewModel = RecipeDetailViewModel(recipeId: selectedRecipe.id)
            let detailViewController = MealDetailViewController(viewModel: recipeDetailViewModel)
            detailViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailViewController,
                                                     animated: true)
        }
    }
}
