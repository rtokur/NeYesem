//
//  FilterOptionCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 25.08.2025.
//

import UIKit

class FilterOptionCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    static let reuseID = "FilterOptionCell"

    override var isSelected: Bool {
        didSet {
            checkImageView.isHidden = !isSelected
            checkbox.layer.borderColor = isSelected ? UIColor.secondaryColor.cgColor : UIColor.Text200.cgColor
        }
    }
    
    //MARK: UI E
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let checkbox: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Text200.cgColor
        view.layer.cornerRadius = 5
        return view
    }()

    private let checkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "check"))
        imageView.tintColor = .white
        imageView.backgroundColor = .secondaryColor
        imageView.isHidden = true
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(14)
        label.textColor = .black
        return label
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(checkbox)
        checkbox.addSubview(checkImageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(9)
        }
        checkbox.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(13)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(title: String) {
        titleLabel.text = title
    }
}

