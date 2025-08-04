//
//  FavoriteViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 1.08.2025.
//

import UIKit

class FavoriteViewController: UIViewController, UITextFieldDelegate {
    private let categories = ["Tüm tarifler", "Kahvaltı", "Yemek", "Tatlı", "Salata"]
    private let mealsArray: [(title: String, type: String)] = [
        ("Kremalı Makarna", "Akşam yemeği"),
        ("Sezar Salata", "Salata"),
        ("Tiramisu", "Tatlı"),
        ("Domates Çorbası", "Akşam yemeği"),
        ("Çilekli Salata", "Salata"),
        ("Sebzeli Krep", "Kahvaltı")
    ]
    private var selectedIndex = 0
    
    //MARK: UI Elements
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
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
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MealTypeCollectionViewCell.self, forCellWithReuseIdentifier: "MealTypeCollectionViewCell")
        return collectionView
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
        collectionView.register(FavoriteMealCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteMealCollectionViewCell")
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
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
        
        self.hideKeyboardOnTap()
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        favoritesLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        searchStackView.snp.makeConstraints { make in
            make.height.equalTo(44)
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
        }
        mealCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}


extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealCollectionView {
            return mealsArray.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mealCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMealCollectionViewCell", for: indexPath) as! FavoriteMealCollectionViewCell
            let meal = mealsArray[indexPath.row]
            cell.configure(mealType: meal.type, mealName: meal.title)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealTypeCollectionViewCell", for: indexPath) as! MealTypeCollectionViewCell
        let isSelected = indexPath.item == selectedIndex
        cell.configure(title: categories[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mealCollectionView {
            let width = (collectionView.frame.width / 2) - 7
            return CGSize(width: width, height: 212)
        }
        let textWidth = categories[indexPath.item].width(using: UIFont.dmSansRegular(11), padding: 30)
        return CGSize(width: textWidth, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
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
