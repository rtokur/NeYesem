//
//  FavoriteMealCollectionViewCell.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 1.08.2025.
//

import UIKit

class FavoriteMealCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    static let reuseID = "FavoriteCell"
    
    var onFavoriteButtonTapped: (() -> Void)?
    
    var isFavorited: Bool = false {
        didSet {
            updateFavoriteIcon()
        }
    }
    
    //MARK: UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .Color10
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var mealLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(13)
        label.textColor = UIColor.Text950
        return label
    }()
    
    private let favoriteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        return view
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "heart")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 11,
                                        weight: .bold)
        button.configuration = configuration
        button.tintColor = UIColor.secondaryColor
        button.addTarget(self,
                         action: #selector(favoriteButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private let favoriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 11,
                                                        weight: .bold)
        let imageView = UIImageView(image: UIImage(systemName: "heart",
                                                   withConfiguration: configuration))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.secondaryColor
        return imageView
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor300
        label.font = UIFont.dmSansRegular(11)
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
        label.font = UIFont.dmSansRegular(12, weight: .thin)
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = mealTypeLabel.text?.width(using: mealTypeLabel.font, padding: 11) ?? 10
        mealTypeView.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealImageView.image = nil
        mealLabel.text = nil
        mealTypeLabel.text = nil
        favoriteLabel.text = nil
        timeLabel.text = nil
        isFavorited = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Setup Methods
    func setupViews(){
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.Text50.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(mealImageView)
        stackView.addArrangedSubview(mealLabel)
        contentView.addSubview(favoriteView)
        favoriteView.addSubview(favoriteButton)
        stackView.addArrangedSubview(favoriteStackView)
        favoriteStackView.addArrangedSubview(favoriteImageView)
        favoriteStackView.addArrangedSubview(favoriteLabel)
        stackView.addArrangedSubview(mealDetailStackView)
        mealDetailStackView.addArrangedSubview(mealTypeView)
        mealTypeView.addSubview(mealTypeLabel)
        mealDetailStackView.addArrangedSubview(dotView)
        dotView.addSubview(dotInsideDotView)
        mealDetailStackView.addArrangedSubview(timeLabel)
        stackView.setCustomSpacing(10, after: mealImageView)
        stackView.setCustomSpacing(8, after: favoriteStackView)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        mealImageView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        mealLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        favoriteView.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.top.trailing.equalTo(mealImageView).inset(8)
        }
        favoriteButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        favoriteStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        favoriteImageView.snp.makeConstraints { make in
            make.width.equalTo(self.favoriteImageView.snp.height)
        }
        mealDetailStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
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
    }
    
    //MARK: - Functions
    func configure(model: RecipeUIModel) {
        mealTypeLabel.text = model.recipe.dishTypes?.first?.capitalized
        mealTypeLabel.textColor = model.color
        mealTypeView.backgroundColor = model.color.withAlphaComponent(0.1)
        mealLabel.text = model.recipe.title
        favoriteLabel.text = "Liked by \(model.likeCount) users"
        self.isFavorited = model.isFavorite
        
        if let urlString = model.recipe.image,
           let url = URL(string: urlString) {
            mealImageView.kf.setImage(
                with: url,
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        }
        
        if let mealTime = model.recipe.readyInMinutes {
            timeLabel.text = "\(mealTime) mn."
        }
    }
    
    private func updateFavoriteIcon() {
        let imageName = isFavorited ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    //MARK: - Actions
    @objc private func favoriteButtonAction() {
        isFavorited.toggle()
        onFavoriteButtonTapped?()
    }
}
