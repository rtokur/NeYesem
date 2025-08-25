//
//  IngredientCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 21.08.2025.
//

import UIKit

class IngredientCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseID = "IngredientCell"
    
    var onValueChanged: ((Double?, String?) -> Void)?

    private(set) var currentUnit: String?
    
    override var isSelected: Bool {
        didSet {
            updateLayout()
        }
    }
    
    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondaryColor
        label.font = .dmSansRegular(12)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 9)
        let imageView = UIImageView(image: UIImage(systemName: "checkmark",
                                                   withConfiguration: configuration))
        imageView.tintColor = .white
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = .dmSansRegular(12)
        textField.backgroundColor = UIColor.Text50
        textField.layer.cornerRadius = 5
        textField.text = "0"
        textField.isHidden = true
        textField.addTarget(self,
                            action: #selector(quantityChanged),
                            for: .editingChanged)
        return textField
    }()
    
    let unitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("adet", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .dmSansRegular(12)
        button.layer.borderColor = UIColor.Text50.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.isHidden = true
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.Text50.cgColor
        contentView.layer.borderWidth = 1
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(quantityTextField)
        stackView.addArrangedSubview(unitButton)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(20)
        }
        quantityTextField.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(50)
        }
        unitButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Functions
    func configure(product: AisleProduct) {
        titleLabel.text = product.name
        quantityTextField.text = "0"
        if let units = product.units,
            let firstUnit = units.first {
            unitButton.setTitle(firstUnit,
                                for: .normal)
            setupUnitMenu(units: units)
        } else {
            unitButton.setTitle("-", for: .normal)
            setupUnitMenu(units: [])
        }
        
        updateLayout()
    }
    
    func configure(with item: IngredientUIModel) {
        titleLabel.text = item.name
        quantityTextField.text = "\(item.amount ?? 0.0)"
        unitButton.setTitle(item.unit, for: .normal)
        updateLayout()
    }
    
    private func setupUnitMenu(units: [String]) {
        var actions: [UIAction] = []
        
        for unit in units {
            let action = UIAction(title: unit, handler: { [weak self] _ in
                self?.unitButton.setTitle(unit, for: .normal)
            })
            actions.append(action)
        }
        if actions.isEmpty {
            actions.append(UIAction(title: "-", handler: { [weak self] _ in
                self?.unitButton.setTitle("-", for: .normal)
            }))
        }
        
        unitButton.menu = UIMenu(children: actions)
        unitButton.showsMenuAsPrimaryAction = true
    }
    
    private func updateLayout() {
        quantityTextField.isHidden = !isSelected
        unitButton.isHidden = !isSelected
        titleLabel.textColor = isSelected ? UIColor.white : .secondaryColor
        contentView.backgroundColor = isSelected ? UIColor.secondaryColor : UIColor.white
        imageView.isHidden = !isSelected
    }
    
    //MARK: - Actions
    @objc private func quantityChanged() {
        let amount = Double(quantityTextField.text ?? "")
        onValueChanged?(amount, currentUnit)
    }
}
