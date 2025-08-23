//
//  InstructionsCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 15.08.2025.
//

import UIKit

class InstructionsCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseID = "InstructionCell"
    
    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text950
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Setup Methods
    func setupViews(){
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.Text50.cgColor
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(stackView2)
        stackView2.addArrangedSubview(numberLabel)
        stackView2.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(textLabel)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        stackView2.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        numberLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    //MARK: - Configure
    func configure(number: Int, text: String) {
        numberLabel.text = "\(number)."
        textLabel.text = text
    }
}
