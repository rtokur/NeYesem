//
//  StatItemView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import UIKit

final class StatItemView: UIView {
    
    //MARK: - UI Elements
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(13)
        label.textColor = UIColor.Secondary800
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(13)
        label.textColor = UIColor.Secondary800
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Initializer
    init(number: Int, title: String) {
        super.init(frame: .zero)
        setupViews()
        configure(number: number, title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    //MARK: - Functions
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [numberLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(number: Int, title: String) {
        numberLabel.text = "\(number)"
        titleLabel.text = title
    }
}
