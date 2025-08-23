//
//  FridgeCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 22.08.2025.
//

import UIKit

class FridgeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseID = "FridgeCell"
    
    private var currentAmount: Int = 0
    private var currentUnit: String = ""
    
    var onAmountChanged: ((Int) -> Void)?
    var didTapDelete: (() -> Void)?
    
    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(12)
        label.textColor = UIColor.textColor900
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 5
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 18,
                                                        weight: .bold)
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash",
                                withConfiguration: configuration),
                        for: .normal)
        button.tintColor = .red
        button.addTarget(self,
                         action: #selector(deleteButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private let unitAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(12)
        label.textColor = UIColor.textColor900
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let plusButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 10,
                                                 weight: .bold)
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus",
                                withConfiguration: config),
                        for: .normal)
        button.tintColor = .red
        button.addTarget(self,
                         action: #selector(plusTapped),
                         for: .touchUpInside)
        return button
    }()

    private let minusButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 10,
                                                 weight: .bold)
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus",
                                withConfiguration: config),
                        for: .normal)
        button.tintColor = .red
        button.addTarget(self,
                         action: #selector(minusTapped),
                         for: .touchUpInside)
        return button
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.Text50.cgColor
        contentView.layer.borderWidth = 1
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(rightStackView)
        rightStackView.addArrangedSubview(deleteButton)
        rightStackView.addArrangedSubview(unitAmountLabel)
        stackView.addArrangedSubview(vStackView)
        vStackView.addArrangedSubview(plusButton)
        vStackView.addArrangedSubview(minusButton)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        rightStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
        unitAmountLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        vStackView.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
    }
    
    //MARK: - Functions
    func configure(with ingredient: IngredientUIModel) {
        titleLabel.text = ingredient.name
        currentAmount = Int(ingredient.amount ?? 0)
        currentUnit = ingredient.unit ?? ""
        updateUnitAmountLabel()
    }

    private func updateUnitAmountLabel() {
        unitAmountLabel.text = "\(currentAmount) \(currentUnit)"
    }
    
    // MARK: - Action
    @objc private func deleteButtonTapped() {
        didTapDelete?()
    }
    
    @objc private func plusTapped() {
        currentAmount += 1
        updateUnitAmountLabel()
        onAmountChanged?(currentAmount)
    }

    @objc private func minusTapped() {
        if currentAmount > 0 {
            currentAmount -= 1
            updateUnitAmountLabel()
            onAmountChanged?(currentAmount)
        }
    }
}
