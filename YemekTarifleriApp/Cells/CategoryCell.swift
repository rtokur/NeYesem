//
//  CategoryCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 20.08.2025.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    //MARK: Properties
    static let reuseID = "CategoryCell"
    
    //MARK: UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(12)
        label.textColor = UIColor.Text950
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(130)
            make.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func configure(with category: CategoryModel) {
        imageView.image = UIImage(named: category.type)
        titleLabel.text = category.title
    }
}
