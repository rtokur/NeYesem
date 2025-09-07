//
//  RecipeCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 22.08.2025.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseID = "RecipeCell"
    var likeButtonAction: (() -> Void)?
    var goButtonAction: (() -> Void)?
    
    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let mealInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLikeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.secondaryColor
        button.addTarget(self,
                             action: #selector(likeButtonTapped),
                             for: .touchUpInside)
        return button
    }()
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let likeImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 11,
                                                        weight: .bold)
        let imageView = UIImageView(image: UIImage(systemName: "heart",
                                                   withConfiguration: configuration))
        imageView.tintColor = UIColor.secondaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(10)
        label.textColor = UIColor.textColor300
        return label
    }()
    
    private let mealDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let mealTypeView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    
    lazy var mealTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.dmSansRegular(11)
        return label
    }()
    
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let dotInsideDotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = UIColor.Color03
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Color999999
        label.font = UIFont.dmSansRegular(12,
                                          weight: .thin)
        return label
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let missingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let missingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor400
        label.font = .dmSansRegular(10)
        return label
    }()
    
    private let goButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"),
                        for: .normal)
        button.tintColor = UIColor.textColor400
        button.addTarget(self,
                         action: #selector(goButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = mealTypeLabel.text?.width(using: mealTypeLabel.font,
                                              padding: 11) ?? 10
        mealTypeView.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: - Setup Methods
    func setupViews(){
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.Text50.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(detailStackView)
        detailStackView.addArrangedSubview(imageView)
        detailStackView.addArrangedSubview(mealInfoStackView)
        mealInfoStackView.addArrangedSubview(titleLikeStackView)
        titleLikeStackView.addArrangedSubview(titleLabel)
        titleLikeStackView.addArrangedSubview(likeButton)
        mealInfoStackView.addArrangedSubview(likeStackView)
        likeStackView.addArrangedSubview(likeImageView)
        likeStackView.addArrangedSubview(likeLabel)
        mealInfoStackView.addArrangedSubview(mealDetailStackView)
        mealDetailStackView.addArrangedSubview(mealTypeView)
        mealTypeView.addSubview(mealTypeLabel)
        mealDetailStackView.addArrangedSubview(dotView)
        dotView.addSubview(dotInsideDotView)
        mealDetailStackView.addArrangedSubview(timeLabel)
        mealDetailStackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(missingStackView)
        missingStackView.addArrangedSubview(missingLabel)
        missingStackView.addArrangedSubview(goButton)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        detailStackView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        imageView.snp.makeConstraints { make in
            make.width.equalTo(130)
        }
        titleLikeStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        likeButton.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        likeStackView.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        likeImageView.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
        mealTypeView.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        mealTypeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        dotView.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        dotInsideDotView.snp.makeConstraints { make in
            make.center.equalTo(dotView)
            make.height.width.equalTo(6)
        }
        timeLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        missingStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        goButton.snp.makeConstraints { make in
            make.width.equalTo(goButton.snp.height)
        }
    }
    
    //MARK: - Configure
    func configure(recipe: RecipeUIModel) {
        titleLabel.text = recipe.recipe.title
        timeLabel.text = "\(recipe.recipe.readyInMinutes ?? 30) mn."
        mealTypeLabel.text = recipe.recipe.dishTypes?.first ?? "Salad"
        likeLabel.text = "Liked by \(recipe.likeCount) users"
        if let missedIngredientCount = recipe.recipe.missedIngredientCount,
           missedIngredientCount != 0{
            let ingredientText = missedIngredientCount == 1 ? "ingredient" : "ingredients"
            missingLabel.text = "\(missedIngredientCount) \(ingredientText) missing!"
        }else {
            missingLabel.text = "No ingredients missing!"
        }

        mealTypeView.backgroundColor = recipe.color.withAlphaComponent(0.1)
        mealTypeLabel.textColor = recipe.color
        if let image = recipe.recipe.image,
           let url = URL(string: image) {
            imageView.kf.setImage(with: url)
        }
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 11,
                                                        weight: .bold)
        let heartImageName = recipe.isFavorite ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: heartImageName, withConfiguration: configuration), for: .normal)
    }
    
    //MARK: - Actions
    @objc private func likeButtonTapped() {
        likeButtonAction?()
    }
    
    @objc private func goButtonTapped() {
        goButtonAction?()
    }
}
