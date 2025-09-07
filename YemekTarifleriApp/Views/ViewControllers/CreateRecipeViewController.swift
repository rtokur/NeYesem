//
//  CreateRecipeViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import UIKit

class CreateRecipeViewController: UIViewController {
    //MARK: Properties
    private let fridgeViewModel = FridgeViewModel()
    private var activeTextField: UITextField?
    
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
        label.text = "Create Recipe"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
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
    
    private let fridgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.Text100.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let fridgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
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
        textField.attributedPlaceholder = NSAttributedString(string: "Add Ingredient",
                                                             
                                                             attributes: attributes)
        textField.delegate = self
        textField.addTarget(self,
                            action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
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
    
    private let fridgeItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var myFridgeLabel: UILabel = {
        let label = UILabel()
        label.text = "Items in my fridge"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.textColor900
        return label
    }()
    
    private lazy var useAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Use All", for: .normal)
        button.titleLabel?.font = .dmSansRegular(12)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapUseAll), for: .touchUpInside)
        return button
    }()
    
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
    
    private let prepareView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.Text100.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let cookStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var preferencesLabel: UILabel = {
        let label = UILabel()
        label.text = "Cooking Preferences"
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.textColor900
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var servingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Servings"
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.textColor900
        return label
    }()
    
    private lazy var cookingMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "Cooking Method"
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.textColor900
        return label
    }()
    
    private let dropdownStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    private let leftDropdown: UIButton = {
        var config = UIButton.Configuration.filled()
        let font = UIFont.dmSansRegular(14)
        config.attributedTitle = AttributedString("Servings", attributes: AttributeContainer([
            .font: font,
            .foregroundColor: UIColor.Text600
        ]))
        config.baseForegroundColor = UIColor.Text600
        config.baseBackgroundColor = .white
        config.cornerStyle = .medium
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        config.image = UIImage(systemName: "chevron.down")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular)

        config.imagePlacement = .trailing
        config.imagePadding = 15
        
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.Text100.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let rightDropdown: UIButton = {
        var config = UIButton.Configuration.filled()
        let font = UIFont.dmSansRegular(14)
        config.attributedTitle = AttributedString( "Select Cooking Method", attributes: AttributeContainer([
            .font: font,
            .foregroundColor: UIColor.Text600
        ]))
        config.baseForegroundColor = UIColor.Text600
        config.baseBackgroundColor = .white
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        config.image = UIImage(systemName: "chevron.down")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular)

        config.imagePlacement = .trailing
        config.imagePadding = 15
        
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.Text100.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Recipe", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.layer.cornerRadius = 15
        button.addTarget(self,
                         action: #selector(createButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private let assistantView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.Text100.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let assistantStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var recipeAssistantLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Assistant"
        label.font = .dmSansSemiBold(14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat with the recipe assistant for tips, suggestions, and support"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .dmSansRegular(12)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let messageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let assistantImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var assistantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "assistant")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var assistantLabel: UILabel = {
        let label = UILabel()
        label.text = "Assistant"
        label.font = .dmSansSemiBold(16)
        label.textColor = .black
        return label
    }()
    
    private let messageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.ColorEFEFEF
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, I am your recipe assistant, here to help you create the best recipes!"
        label.font = .dmSansRegular(12)
        label.textColor = UIColor.Color57565B
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "08:16"
        label.font = .dmSansRegular(14)
        label.textColor = .black.withAlphaComponent(0.4)
        label.textAlignment = .right
        return label
    }()
    
    private let userMessageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .primaryColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var userMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "I want to make creamy mushroom pasta. How long should I cook the pasta?"
        label.font = .dmSansRegular(12)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var userTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Now"
        label.font = .dmSansRegular(14)
        label.textColor = .black.withAlphaComponent(0.4)
        label.textAlignment = .left
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Text100
        return view
    }()
    
    private let writeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var writeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.textColor900
        textField.font = UIFont.dmSansRegular(14)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textColor300,
            .font: UIFont.dmSansRegular(14,
                                        weight: .thin)
        ]
        textField.tintColor = UIColor.textColor300
        textField.attributedPlaceholder = NSAttributedString(string: "Ask questions about the recipe...",
                                                             attributes: attributes)
        textField.addTarget(self,
                            action: #selector(searchTextChanged(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    private lazy var imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"),
                        for: .normal)
        button.tintColor = UIColor.textColor500
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .primaryColor
        button.layer.cornerRadius = 20
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        hideKeyboardOnTap()
        setupKeyboardObservers()
        setupDropdownMenus()
        
        bindViewModel()
        fridgeViewModel.fetchFridgeItems()
    }

    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        titleLabel.addSubview(backButton)
        stackView.addArrangedSubview(fridgeView)
        fridgeView.addSubview(fridgeStackView)
        fridgeStackView.addArrangedSubview(searchStackView)
        searchStackView.addArrangedSubview(customSearchBarView)
        customSearchBarView.addSubview(searchBarStackView)
        searchBarStackView.addArrangedSubview(iconImageView)
        searchBarStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(filterButton)
        fridgeStackView.addArrangedSubview(fridgeItemsStackView)
        fridgeItemsStackView.addArrangedSubview(myFridgeLabel)
        fridgeItemsStackView.addArrangedSubview(useAllButton)
        fridgeStackView.addArrangedSubview(productsCollectionView)
        stackView.addArrangedSubview(prepareView)
        prepareView.addSubview(cookStackView)
        cookStackView.addArrangedSubview(preferencesLabel)
        cookStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(servingsLabel)
        labelsStackView.addArrangedSubview(cookingMethodLabel)
        cookStackView.addArrangedSubview(dropdownStackView)
        dropdownStackView.addArrangedSubview(leftDropdown)
        dropdownStackView.addArrangedSubview(rightDropdown)
        cookStackView.setCustomSpacing(5, after: labelsStackView)
        stackView.addArrangedSubview(createButton)
        stackView.addArrangedSubview(assistantView)
        assistantView.addSubview(assistantStackView)
        assistantStackView.addArrangedSubview(recipeAssistantLabel)
        assistantStackView.addArrangedSubview(descriptionLabel)
        assistantStackView.setCustomSpacing(30, after: descriptionLabel)
        assistantStackView.addArrangedSubview(messageStackView)
        messageStackView.addArrangedSubview(assistantImageStackView)
        assistantImageStackView.addArrangedSubview(assistantImageView)
        assistantImageStackView.addArrangedSubview(emptyView)
        messageStackView.addArrangedSubview(informationStackView)
        informationStackView.addArrangedSubview(assistantLabel)
        informationStackView.addArrangedSubview(messageView)
        messageView.addSubview(messageLabel)
        informationStackView.addArrangedSubview(timeLabel)
        assistantStackView.setCustomSpacing(35, after: messageStackView)
        assistantStackView.addArrangedSubview(userMessageView)
        userMessageView.addSubview(userMessageLabel)
        assistantStackView.setCustomSpacing(5, after: userMessageView)
        assistantStackView.addArrangedSubview(userTimeLabel)
        assistantStackView.addArrangedSubview(lineView)
        assistantStackView.addArrangedSubview(writeStackView)
        writeStackView.addArrangedSubview(writeTextField)
        writeStackView.addArrangedSubview(imageButton)
        writeStackView.addArrangedSubview(sendButton)
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
            make.leading.trailing.equalToSuperview().inset(15)
        }
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        fridgeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        fridgeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        searchStackView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
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
        fridgeItemsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        useAllButton.snp.makeConstraints { make in
            make.width.equalTo(55)
        }
        productsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        prepareView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        cookStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        preferencesLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        labelsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        servingsLabel.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        dropdownStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        leftDropdown.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        createButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        assistantView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        assistantStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(15)
        }
        recipeAssistantLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        messageStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        assistantImageStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(30)
        }
        assistantImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        emptyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        informationStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        messageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        userMessageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        userMessageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        userTimeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        lineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2)
        }
        writeStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        imageButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        sendButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupDropdownMenus() {
        let servingsOptions = [
            UIAction(title: "1 Serving") { _ in
                let font = UIFont.dmSansRegular(14)
                self.leftDropdown.configuration?.attributedTitle = AttributedString( "1 Serving", attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: UIColor.Text600
                ]))
            },
            UIAction(title: "2 Servings") { _ in
                let font = UIFont.dmSansRegular(14)
                self.leftDropdown.configuration?.attributedTitle = AttributedString( "2 Servings", attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: UIColor.Text600
                ]))
            },
            UIAction(title: "3 Servings") { _ in
                let font = UIFont.dmSansRegular(14)
                self.leftDropdown.configuration?.attributedTitle = AttributedString( "3 Servings", attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: UIColor.Text600
                ]))
            }
        ]
        
        leftDropdown.menu = UIMenu(children: servingsOptions)
        leftDropdown.showsMenuAsPrimaryAction = true
        
        let cookingOptions = [
            UIAction(title: "Bake") { _ in
                let font = UIFont.dmSansRegular(14)
                self.rightDropdown.configuration?.attributedTitle = AttributedString( "Bake", attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: UIColor.Text600
                ]))
            },
            UIAction(title: "Fry") { _ in
                let font = UIFont.dmSansRegular(14)
                self.rightDropdown.configuration?.attributedTitle = AttributedString( "Fry", attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: UIColor.Text600
                ]))
            },
            UIAction(title: "Boil") { _ in
                let font = UIFont.dmSansRegular(14)
                self.rightDropdown.configuration?.attributedTitle = AttributedString( "Boil", attributes: AttributeContainer([
                    .font: font,
                    .foregroundColor: UIColor.Text600
                ]))
            }
        ]
        
        rightDropdown.menu = UIMenu(children: cookingOptions)
        rightDropdown.showsMenuAsPrimaryAction = true
    }

    //MARK: - Bind ViewModel
    private func bindViewModel() {
        fridgeViewModel.onFridgeUpdated = { [weak self] in
            guard let self else { return }
            self.productsCollectionView.reloadData()
            self.productsCollectionView.layoutIfNeeded()
            self.productsCollectionView.snp.updateConstraints { make in
                make.height.equalTo(self.productsCollectionView.collectionViewLayout.collectionViewContentSize.height)
            }
        }
        
        fridgeViewModel.onError = { errorMessage in
            print("Fridge error: \(errorMessage)")
        }
    }
    
    
    //MARK: - Actions
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func createButtonAction() {
        let loadingViewController = LoadingViewController()
        navigationController?.pushViewController(loadingViewController, animated: true)
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        
    }
    
    @objc private func didTapUseAll() {
        let sectionCount = productsCollectionView.numberOfSections
        
        for section in 0..<sectionCount {
            let itemCount = productsCollectionView.numberOfItems(inSection: section)
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                productsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                
                if let cell = productsCollectionView.cellForItem(at: indexPath) {
                    cell.isSelected = true
                }
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.productsCollectionView.collectionViewLayout.invalidateLayout()
            self.productsCollectionView.layoutIfNeeded()
            
            self.productsCollectionView.snp.updateConstraints { make in
                make.height.equalTo(self.productsCollectionView.collectionViewLayout.collectionViewContentSize.height)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset.bottom = keyboardHeight + 20
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 20
            
            if let activeTextField = activeTextField {
                let textFieldFrame = activeTextField.convert(activeTextField.bounds,
                                                             to: scrollView)
                scrollView.scrollRectToVisible(textFieldFrame,
                                               animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

//MARK: - Delegates
extension CreateRecipeViewController: UITextFieldDelegate, UICollectionViewDelegate,
                                      UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fridgeViewModel.filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IngredientCollectionViewCell.reuseID,
            for: indexPath
        ) as? IngredientCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = fridgeViewModel.filteredItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = fridgeViewModel.filteredItems[indexPath.item]
        
        let font = UIFont.dmSansRegular(12)
        let textSize = item.name.size(withAttributes: [.font: font])
        
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
        if textField == searchTextField {
            customSearchBarView.layer.borderColor = UIColor.primaryColor.cgColor
            iconImageView.tintColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTextField {
            customSearchBarView.layer.borderColor = UIColor.textColor300.cgColor
            iconImageView.tintColor = UIColor.textColor300
        }
    }
}

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY , maxY)
            }
        }
        return attributes
    }
}
