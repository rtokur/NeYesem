//
//  AddIngredientsViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 19.08.2025.
//

import UIKit

class AddIngredientsViewController: UIViewController {
    //MARK: - Properties
    private let viewModel = IngredientViewModel()
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Fridge"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
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
        textField.attributedPlaceholder = NSAttributedString(string: "Add Ingredient",
                                                             attributes: attributes)
        textField.addTarget(self, action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    private let categoryBar = CategoryBarView()
    
    private lazy var productsCollectionView: UICollectionView = {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(IngredientCollectionViewCell.self,
                                forCellWithReuseIdentifier: IngredientCollectionViewCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private lazy var addIngredientButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor.primaryColor
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        let titleFont = UIFont.dmSansBold(16)
        let titleAttr = AttributedString("Add Ingredients",
                                         attributes: AttributeContainer([
                                            .font: titleFont
                                         ]))
        configuration.attributedTitle = titleAttr
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.addTarget(self,
                         action: #selector(addIngredientAction),
                         for: .touchUpInside)
        return button
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSuggestionHighlights()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        view.addSubview(backButton)
        stackView.addArrangedSubview(customSearchBarView)
        customSearchBarView.addSubview(searchBarStackView)
        searchBarStackView.addArrangedSubview(iconImageView)
        searchBarStackView.addArrangedSubview(searchTextField)
        searchTextField.delegate = self
        stackView.addArrangedSubview(categoryBar)
        stackView.addArrangedSubview(productsCollectionView)
        stackView.addArrangedSubview(addIngredientButton)
        view.addSubview(suggestionView)
        suggestionView.addSubview(suggestionStackView)
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(15)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(15)
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
        categoryBar.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalToSuperview()
        }
        productsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(1)
        }
        addIngredientButton.snp.makeConstraints { make in
            make.height.equalTo(50)
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
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onSuggestionsUpdated = { [weak self] in
            guard let self else { return }
            self.updateSuggestions()
        }
        viewModel.onProductsUpdated = { [weak self] in
            self?.productsCollectionView.reloadData()
            self?.productsCollectionView.layoutIfNeeded()
            self?.productsCollectionView.snp.updateConstraints { make in
                make.height.equalTo(self?.productsCollectionView.collectionViewLayout.collectionViewContentSize.height ?? 1)
            }
        }
        viewModel.onSaveCompleted = { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        viewModel.onError = { errorMessage in
            let alert = CustomAlertView(
                titleText: errorMessage,
                confirmText: "OK",
                cancelText: "Cancel",
                isConfirmHidden: true
            )
            alert.onConfirm = { [weak alert] in
                alert?.dismiss()
            }
            alert.onCancel = { [weak alert] in
                alert?.dismiss()
            }
            alert.present(on: self)
        }
        categoryBar.categories = viewModel.allAisles
        categoryBar.onSelectionChanged = { [weak self] aisle, index in
            guard let self else { return }
            self.viewModel.selectAisle(aisle)
        }
        if let firstAisle = viewModel.allAisles.first {
            viewModel.selectAisle(firstAisle)
            categoryBar.select(index: 0,
                               animated: true)
        }
    }
    
    // MARK: - Update Suggestions
    private func updateSuggestions() {
        suggestionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !viewModel.suggestions.isEmpty else {
            suggestionView.isHidden = true
            return
        }
        suggestionView.isHidden = false
        
        for (index, ingredient) in viewModel.suggestions.enumerated() {
            let container = UIView()
            container.tag = index
            container.layer.cornerRadius = 8
            container.layer.masksToBounds = true
            container.backgroundColor = (index == selectedSuggestionIndex) ? UIColor.Text50 : .white
            
            let label = UILabel()
            label.text = ingredient.name
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
    
    @objc private func dismissKeyboardAndHideSuggestions() {
        view.endEditing(true)
        resetSuggestionHighlights()
    }
    
    @objc private func addIngredientAction() {
        guard let selectedIndexPaths = productsCollectionView.indexPathsForSelectedItems,
              !selectedIndexPaths.isEmpty else {
            let alert = CustomAlertView(
                titleText: "Please select at least one product.",
                confirmText: "",
                cancelText: "OK",
                isConfirmHidden: true
            )
            alert.onConfirm = { [weak alert] in
                alert?.dismiss()
            }
            alert.present(on: self)
            return
        }
        
        var ingredients: [IngredientUIModel] = []
        var hasInvalidAmount = false
        
        for indexPath in selectedIndexPaths {
            let item = viewModel.selectedAisleProducts[indexPath.item]
            
            guard let cell = productsCollectionView.cellForItem(at: indexPath) as? IngredientCollectionViewCell else {
                continue
            }
            
            let amount = Double(cell.quantityTextField.text ?? "0") ?? 0
            let unit = cell.unitButton.titleLabel?.text
            
            if amount <= 0 {
                hasInvalidAmount = true
                break
            }
            
            let ingredient = IngredientUIModel(
                id: nil,
                name: item.name,
                amount: amount,
                unit: unit,
                aisle: viewModel.selectedAisle
            )
            ingredients.append(ingredient)
        }
        
        if hasInvalidAmount {
            let alert = CustomAlertView(
                titleText: "Products with zero amount cannot be added. Please enter a valid quantity.",
                confirmText: "",
                cancelText: "OK",
                isConfirmHidden: true
            )
            alert.onConfirm = { [weak alert] in
                alert?.dismiss()
            }
            alert.present(on: self)
            return
        }
        
        viewModel.selectedProducts = ingredients
        viewModel.saveSelectedProductsToFridge()
    }
    
    @objc private func suggestionTapped(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view else { return }
        let index = container.tag
        selectedSuggestionIndex = index
        container.backgroundColor = UIColor.Text50
        
        let ingredient = viewModel.suggestions[index]
        let productName = ingredient.name.capitalized
        searchTextField.text = productName
        suggestionView.isHidden = true
        
        let aisleName = viewModel.aisle(for: productName) ?? ingredient.aisle?.capitalized ?? ""
        
        if !categoryBar.categories.contains(aisleName) {
            categoryBar.addCategory(aisleName)
        }
        if let aisleIndex = categoryBar.categories.firstIndex(of: aisleName) {
            categoryBar.select(index: aisleIndex)
        }
        
        if let existingIndex = viewModel.selectedAisleProducts.firstIndex(where: { $0.name == productName }) {
            productsCollectionView.reloadData()
            let indexPath = IndexPath(item: existingIndex, section: 0)
            productsCollectionView.selectItem(at: indexPath,
                                              animated: true,
                                              scrollPosition: .centeredVertically)
        } else {
            let newProduct = AisleProduct(name: productName, units: ingredient.possibleUnits ?? [""])
            
            viewModel.addProduct(newProduct, to: aisleName)
            
            productsCollectionView.reloadData()
            
            if let newIndex = viewModel.selectedAisleProducts.firstIndex(where: { $0.name == productName }) {
                let newIndexPath = IndexPath(item: newIndex, section: 0)
                productsCollectionView.selectItem(at: newIndexPath, animated: true,
                                                  scrollPosition: .centeredVertically)
            }
        }
    }
    
    @objc private func performSearch(_ query: String) {
        viewModel.fetchSuggestions(query: query)
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Data Source, Delegate
extension AddIngredientsViewController: UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedAisleProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionViewCell.reuseID, for: indexPath) as! IngredientCollectionViewCell
        let product = viewModel.selectedAisleProducts[indexPath.item]
        cell.configure(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = viewModel.selectedAisleProducts[indexPath.item].name as NSString
        let font = UIFont.dmSansRegular(12)
        let textSize = title.size(withAttributes: [.font: font])
        
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        let extraWidth: CGFloat = isSelected ? 140 : 0
        
        return CGSize(width: ceil(textSize.width) + 20 + extraWidth,
                      height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
            
            collectionView.snp.updateConstraints { make in
                make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
            
            collectionView.snp.updateConstraints { make in
                make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
            }
            self.view.layoutIfNeeded()
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
