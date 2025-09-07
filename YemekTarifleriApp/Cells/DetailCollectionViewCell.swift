//
//  DetailCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 14.08.2025.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    static let reuseID = "DetailCell"
    
    //MARK: UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(10)
        label.textColor = UIColor.textColor500
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Init
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    //MARK: Configure
    func configure(image: UIImage?, name: String) {
        imageView.image = image
        label.text = name
    }
}
