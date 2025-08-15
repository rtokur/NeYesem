//
//  MealDetailViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 14.08.2025.
//

import UIKit

class MealDetailViewController: UIViewController {
    private let viewModel: RecipeDetailViewModel
    private var items: [(UIImage?, String)] = []
    private var didTrackRecentOnce = false
    
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
    
    private lazy var headStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
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
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let favoriteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "heart")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12,
                                                                                         weight: .bold)
        button.configuration = configuration
        button.tintColor = UIColor.secondaryColor
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.textColor900
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = UIColor.secondaryColor
        return imageView
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(12)
        label.textColor = UIColor.textColor300
        label.text = "72 kişi bu tarifi beğendi"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.textColor400
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var detailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 15,
                                                   bottom: 0,
                                                   right: 15)
        return collectionView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Malzemeler",
                                                          "Yapılışı"])
        segmentedControl.selectedSegmentIndex = 0
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryColor,
            .font: UIFont.dmSansSemiBold(16)
        ]
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textColor500,
            .font: UIFont.dmSansSemiBold(16)
        ]
        
        segmentedControl.setTitleTextAttributes(normalAttributes,
                                                for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes,
                                                for: .selected)
        
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedControlClicked(_:)),
                                   for: .valueChanged)
        
        return segmentedControl
    }()
    
    private let ingredientsView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let recipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.isHidden = true
        return view
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
        stackView.addArrangedSubview(headStackView)
        headStackView.addArrangedSubview(backButton)
        headStackView.addArrangedSubview(emptyView)
        headStackView.addArrangedSubview(exportButton)
        stackView.addArrangedSubview(mealImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(likeStackView)
        likeStackView.addArrangedSubview(likeImageView)
        likeStackView.addArrangedSubview(likeLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.setCustomSpacing(10, after: titleLabel)
        stackView.setCustomSpacing(10, after: likeStackView)
        scrollView.addSubview(favoriteView)
        favoriteView.addSubview(favoriteButton)
        stackView.addArrangedSubview(detailCollectionView)
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(ingredientsView)
        stackView.addArrangedSubview(recipeView)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        headStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        exportButton.snp.makeConstraints { make in
            make.width.equalTo(44)
        }
        mealImageView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        likeStackView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        likeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        favoriteView.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.trailing.equalToSuperview().inset(25)
            make.top.equalTo(mealImageView).inset(10)
        }
        favoriteButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        detailCollectionView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        segmentedControl.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        ingredientsView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        recipeView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }

    private func bindViewModel() {
        viewModel.onDataFetched = { [weak self] in
            guard let self = self else { return }

            if let url = self.viewModel.imageUrl {
                self.mealImageView.kf.setImage(with: url)
            }
            self.titleLabel.text = self.viewModel.titleText
            self.descriptionLabel.text = self.viewModel.descriptionText
            self.items = [
                (UIImage(named: "time"), "\(self.viewModel.timeText) dakika"),
                (UIImage(named: "serving"), "\(self.viewModel.servingsText) kişilik"),
                (UIImage(named: "calory"), "\(self.viewModel.caloriesText) kalori"),
                (UIImage(named: "type"), self.viewModel.typeText)
            ]
            self.detailCollectionView.reloadData()

            if !self.didTrackRecentOnce {
                self.viewModel.trackCurrentAsRecent()
                self.didTrackRecentOnce = true
            }

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
    
    @objc func segmentedControlClicked(_ sender: UISegmentedControl) {
        ingredientsView.isHidden = sender.selectedSegmentIndex == 1
        recipeView.isHidden = sender.selectedSegmentIndex == 0
        
    }
}

extension MealDetailViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseID, for: indexPath) as! DetailCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(image: item.0,
                       name: item.1)
        return cell
    }
    
    
}
