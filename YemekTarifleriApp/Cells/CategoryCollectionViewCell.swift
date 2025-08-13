//
//  CategoryCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 12.08.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseID = "CategoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(11)
        label.textColor = UIColor.textColor400
        label.textAlignment = .center
        return label
    }()
    
    var selectedBackground: UIColor = UIColor.secondaryColor
    var deselectedBackground: UIColor = .white
    var selectedTextColor: UIColor = .white
    var deselectedTextColor: UIColor = UIColor.textColor400
    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
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
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func updateAppearance() {
        if isSelected {
            contentView.backgroundColor = selectedBackground
            titleLabel.textColor = selectedTextColor
            contentView.layer.borderColor = selectedBackground.cgColor
        } else {
            contentView.backgroundColor = deselectedBackground
            titleLabel.textColor = deselectedTextColor
            contentView.layer.borderColor = UIColor.Text50.cgColor
        }
    }
}
