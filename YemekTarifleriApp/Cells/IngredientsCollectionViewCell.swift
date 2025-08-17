//
//  IngredientsCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 15.08.2025.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    static let reuseID = "IngredientCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Text950
        label.font = .dmSansRegular(14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(text: String) {
        titleLabel.text = " •  \(text)"
    }
    
}
