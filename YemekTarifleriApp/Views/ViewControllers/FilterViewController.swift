//
//  FilterViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 24.08.2025.
//

import UIKit
import SnapKit

class FilterViewController: UIViewController {

    // MARK: - Properties
    private let categories = ["Main Course", "Side Dish", "Dessert", "Appetizer", "Salad", "Soup", "Bread", "Breakfast", "Beverage", "Snack", "Sauce", "Drink"]
    private var selectedCategories: Set<String> = []
    var onApply: ((Set<String>) -> Void)?
    private var collectionViewHeightConstraint: Constraint?

    // MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.font = .dmSansSemiBold(18)
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.font = .dmSansRegular(18)
        label.textColor = .textColor400
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
        collectionView.register(FilterOptionCollectionViewCell.self,
                    forCellWithReuseIdentifier: FilterOptionCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.backgroundColor = .white
        button.setTitleColor(.primaryColor, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.primaryColor.cgColor
        button.addTarget(self,
                         action: #selector(resetTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self,
                      action: #selector(applyTapped),
                      for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        collectionViewHeightConstraint?.update(offset: collectionView.contentSize.height)
    }

    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(buttonStackView)

        buttonStackView.addArrangedSubview(resetButton)
        buttonStackView.addArrangedSubview(applyButton)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        collectionView.snp.makeConstraints { make in
            collectionViewHeightConstraint = make.height.equalTo(1).constraint
        }
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

    // MARK: - Actions
    @objc private func resetTapped() {
        selectedCategories.removeAll()
        collectionView.reloadData()
    }

    @objc private func applyTapped() {
        onApply?(selectedCategories)
        dismiss(animated: true)
    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterOptionCollectionViewCell.reuseID,
                                                      for: indexPath) as! FilterOptionCollectionViewCell
        let category = categories[indexPath.item]
        cell.configure(title: category)
        cell.isSelected = selectedCategories.contains(category)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategories.insert(category)

        if let cell = collectionView.cellForItem(at: indexPath) as? FilterOptionCollectionViewCell {
            cell.isSelected = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategories.remove(category)

        if let cell = collectionView.cellForItem(at: indexPath) as? FilterOptionCollectionViewCell {
            cell.isSelected = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: 36)
    }
}
