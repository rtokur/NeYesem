//
//  FridgeViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class FridgeViewController: UIViewController {
    //MARK: UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dolabım"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Dolabındaki malzemeleri listele, sana özel tarifler önerelim!"
        label.font = .dmSansRegular(14, weight: .thin)
        label.textColor = UIColor.Text600
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let categoryBar = CategoryBarView()
    
    private lazy var addIngredientButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor.primaryColor
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        

        let titleFont = UIFont.dmSansBold(16)
        let titleAttr = AttributedString("Yeni malzeme ekle",
                                         attributes: AttributeContainer([
            .font: titleFont
        ]))
        configuration.attributedTitle = titleAttr

        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 10,
                                                            weight: .bold)
        configuration.image = UIImage(systemName: "plus",
                                      withConfiguration: iconConfiguration)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 5

        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(categoryBar)
        stackView.addArrangedSubview(addIngredientButton)
        
        categoryBar.onSelectionChanged = { [weak self] title, index in
            guard let self else { return }
            print("Seçilen kategori: \(title) - index: \(index)")
        }
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        categoryBar.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalToSuperview()
        }
        addIngredientButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }

}
