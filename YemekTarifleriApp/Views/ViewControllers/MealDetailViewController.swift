//
//  MealDetailViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 14.08.2025.
//

import UIKit

class MealDetailViewController: UIViewController {
    private let viewModel: RecipeDetailViewModel
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "export"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        return button
    }()
    
    private lazy var mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "heart.fill")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 11)
        button.configuration = configuration
        button.tintColor = UIColor.secondaryColor
        return button
    }()
    
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.fetchRecipeDetail()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        view.addSubview(backButton)
        view.addSubview(exportButton)
        stackView.addArrangedSubview(mealImageView)
        view.addSubview(favoriteButton)
        self.hideKeyboardOnTap()
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        exportButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        mealImageView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.leading.trailing.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.top.trailing.equalTo(mealImageView).inset(5)
        }
    }

    private func bindViewModel() {
        viewModel.onDataFetched = { [weak self] in
            guard let self = self else { return }
            
            print(self.viewModel.imageUrl)
            print(self.viewModel.titleText)
            print(self.viewModel.descriptionText)
            print(self.viewModel.servingsText)
            print(self.viewModel.timeText)
            print(self.viewModel.typeText)
            print(self.viewModel.caloriesText)
            print(self.viewModel.ingredientsText)
            print(self.viewModel.instructionsText)
        }
        
        viewModel.onError = { error in
            print("Hata:", error.localizedDescription)
        }
    }
    //MARK: - Actions
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}
