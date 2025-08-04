//
//  MealTypeCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class MealTypeCollectionViewCell: UICollectionViewCell {
    //MARK: UI Elements
    lazy var mealTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(11)
        return label
    }()
 
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
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.Text50.cgColor
        contentView.layer.borderWidth = 1
        contentView.addSubview(mealTypeLabel)
        
    }
    
    func setupConstraints(){
        mealTypeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(title: String, isSelected: Bool) {
        mealTypeLabel.text = title
        if isSelected {
            contentView.backgroundColor = UIColor.secondaryColor
            mealTypeLabel.textColor = .white
        } else {
            contentView.backgroundColor = .clear
            mealTypeLabel.textColor = UIColor.textColor300
        }
    }
}
