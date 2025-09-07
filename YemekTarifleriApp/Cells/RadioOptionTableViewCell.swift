//
//  RadioOptionTableViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 25.08.2025.
//

import UIKit

final class RadioOptionTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let reuseID = "RadioOptionCell"
    
    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let radioOuter: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.textColor300.cgColor
        return view
    }()
    
    private let radioInner: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .secondaryColor
        view.isHidden = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(16)
        label.textColor = .black
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(radioOuter)
        stackView.addArrangedSubview(titleLabel)
        radioOuter.addSubview(radioInner)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
        radioOuter.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        radioInner.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    
    //MARK: - Configure
    func configure(title: String, selected: Bool) {
        titleLabel.text = title
        radioInner.isHidden = !selected
        radioOuter.layer.borderColor = selected ? UIColor.secondaryColor.cgColor : UIColor.textColor300.cgColor
    }
}

