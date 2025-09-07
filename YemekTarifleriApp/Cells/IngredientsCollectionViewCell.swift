//
//  IngredientsCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 15.08.2025.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseID = "IngredientsCell"
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Text950
        label.font = .dmSansRegular(14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Configure
    func configure(text: String) {
        titleLabel.text = " •  \(text)"
    }
    
}
