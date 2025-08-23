//
//  CategoryCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 12.08.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    static let reuseID = "CategoryCollectionViewCell"
    
    override var isSelected: Bool {
        didSet { titleLabel.backgroundColor = isSelected ? UIColor.secondaryColor : UIColor.white; titleLabel.textColor = isSelected ? .white : .systemGray }
    }
    
    //MARK: UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(12)
        label.textColor = UIColor.textColor400
        label.textAlignment = .center
        return label
    }()

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.Text50.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: Configure
    func configure(title: String) {
        titleLabel.text = title
    }
}
