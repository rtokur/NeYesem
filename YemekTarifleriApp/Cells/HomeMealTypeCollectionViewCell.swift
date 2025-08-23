//
//  HomeMealTypeCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//

import UIKit

class HomeMealTypeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseID = "HomeMealTypeCell"
    
    //MARK: UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var mealLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(12)
        label.textColor = UIColor.Text950
        return label
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(mealImageView)
        stackView.addArrangedSubview(mealLabel)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.width.equalTo(80)
        }
        mealImageView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalToSuperview()
        }
    }
    
    //MARK: - Configure
    func configure(mealPhotoName: String, mealName: String) {
        mealLabel.text = mealName
        mealImageView.image = UIImage(named: mealPhotoName)
    }
    
}
