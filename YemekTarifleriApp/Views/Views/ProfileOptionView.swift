//
//  ProfileOptionView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import UIKit

class ProfileOptionView: UIView {
    
    //MARK: - UI Elements
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.secondaryColor
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(15)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 12)
        imageView.image = UIImage(systemName: "chevron.right")?.withConfiguration(configuration)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.textColor900
        return imageView
    }()
    
    //MARK: - Initializer
    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)
        setupViews()
        configure(icon: icon, title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    //MARK: - Functions
    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, arrowImageView])
        stack.axis = .horizontal
        stack.spacing = 10
        addSubview(stack)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        arrowImageView.snp.makeConstraints { make in
            make.width.equalTo(28)
        }
    }
    
    func configure(icon: UIImage?, title: String) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 13)
        iconImageView.image = icon?.withConfiguration(configuration)
        titleLabel.text = title
    }
}
