//
//  MealTypeCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class MealTypeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseID = "MealTypeCollectionViewCell"
    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    var selectedBackground: UIColor = UIColor.secondaryColor
    var deselectedBackground: UIColor = .white
    var selectedTextColor: UIColor = .white
    var deselectedTextColor: UIColor = UIColor.textColor400
    
    //MARK: UI Elements
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(11)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.Text50.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4))
        }
        
        updateAppearance()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Functions
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func updateAppearance() {
        if isSelected {
            contentView.backgroundColor = selectedBackground
            contentView.layer.borderColor = selectedBackground.cgColor
            titleLabel.textColor = selectedTextColor
        } else {
            contentView.backgroundColor = deselectedBackground
            contentView.layer.borderColor = UIColor.Text50.cgColor
            titleLabel.textColor = deselectedTextColor
        }
    }
}
