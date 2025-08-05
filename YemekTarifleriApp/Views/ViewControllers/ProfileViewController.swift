//
//  ProfileViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Properties
    private let viewModel = ProfileViewModel()
    
    //MARK: UI Elements
    private let scrollView: UIScrollView = {
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
    
    private lazy var myProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "Profilim"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Primary800
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(18)
        label.textColor = UIColor.textColor300
        label.textAlignment = .center
        return label
    }()
    
    private let preferenceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.Text200.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let preferenceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var myPreferenceLabel: UILabel = {
        let label = UILabel()
        label.text = "Tercihlerim"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Primary900
        label.textAlignment = .left
        return label
    }()
    
    private lazy var editPreferenceButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        
        var attributedTitle = AttributedString("Profili Düzenle")
        attributedTitle.font = .dmSansSemiBold(11)
        attributedTitle.foregroundColor = UIColor.primaryColor
        configuration.attributedTitle = attributedTitle
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 11, weight: .bold)
        configuration.image = UIImage(systemName: "square.and.pencil")?.withConfiguration(symbolConfiguration)
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3
        configuration.baseForegroundColor = UIColor.primaryColor
        configuration.baseBackgroundColor = .clear
        
        configuration.background.strokeColor = UIColor.primaryColor
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 20
        button.configuration = configuration
        
        return button
    }()
    
    private lazy var dietLabel: UILabel = {
        let label = UILabel()
        label.text = "Beslenme tarzı: "
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Primary800
        label.textAlignment = .left
        return label
    }()
    
    private lazy var allergyLabel: UILabel = {
        let label = UILabel()
        label.text = "Alerji: "
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Primary800
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dontLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "Sevmediğim ürünler: "
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Primary800
        label.textAlignment = .left
        return label
    }()
    
    private lazy var statsContainerView: UIStackView = {
        let savedView = StatItemView(number: 23, title: "Kaydedilen tarifler")
        let completedView = StatItemView(number: 12, title: "Tamamlanan tarifler")
        
        let stackView = UIStackView(arrangedSubviews: [
            savedView,
            makeDivider(length: 60, color: UIColor.Text200),
            favoriteView,
            makeDivider(length: 60, color: UIColor.Text200),
            completedView
        ])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.layer.borderColor = UIColor.Secondary100.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 25

        [savedView, favoriteView, completedView].forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalToSuperview().dividedBy(3).offset(-2)
            }
        }
        return stackView
    }()
    
    private lazy var favoriteView: StatItemView = {
        let view = StatItemView(number: 5, title: "Favoriler")
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var optionsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.Text100.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var optionsContainerStackView: UIStackView = {
        let shoppingList = ProfileOptionView(icon: UIImage(systemName: "cart"), title: "Alışveriş Listelerim")
        let orders = ProfileOptionView(icon: UIImage(systemName: "bell"), title: "Bildirimler")
        let settings = ProfileOptionView(icon: UIImage(systemName: "globe"), title: "Dil Seçenekleri")
        let help = ProfileOptionView(icon: UIImage(systemName: "gearshape"), title: "Ayarlar")
        
        let stackView = UIStackView(arrangedSubviews: [
            shoppingList,
            makeDivider(color: UIColor.Text100),
            orders,
            makeDivider(color: UIColor.Text100),
            settings,
            makeDivider(color: UIColor.Text100),
            help
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.loadUserProfile()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(myProfileLabel)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(profileNameLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(preferenceView)
        preferenceView.addSubview(preferenceStackView)
        preferenceStackView.addArrangedSubview(myPreferenceLabel)
        preferenceStackView.addArrangedSubview(dietLabel)
        preferenceStackView.addArrangedSubview(allergyLabel)
        preferenceStackView.addArrangedSubview(dontLikeLabel)
        preferenceView.addSubview(editPreferenceButton)
        stackView.addArrangedSubview(statsContainerView)
        stackView.addArrangedSubview(optionsView)
        optionsView.addSubview(optionsContainerStackView)
        stackView.setCustomSpacing(10, after: profileImageView)
        stackView.setCustomSpacing(10, after: profileNameLabel)
        self.hideKeyboardOnTap()
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        myProfileLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(120)
        }
        profileNameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        preferenceView.snp.makeConstraints { make in
            make.height.equalTo(108)
            make.width.equalToSuperview()
        }
        preferenceStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        myPreferenceLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        dietLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        allergyLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        dontLikeLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        editPreferenceButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.height.equalTo(32)
            make.width.equalTo(120)
        }
        statsContainerView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalToSuperview()
        }
        optionsView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        optionsContainerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    //MARK: - Functions
    private func bindViewModel() {
        viewModel.onUserDataFetched = { [weak self] user in
            DispatchQueue.main.async {
                self?.profileNameLabel.text = user.displayName
                self?.emailLabel.text = user.email
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func makeDivider(length: CGFloat? = nil, color: UIColor) -> UIView {
        let divider = UIView()
        divider.backgroundColor = color
        if let length = length {
            divider.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(length)
            }
        } else {
            divider.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        return divider
    }
    
    //MARK: - Actions
    @objc private func favoriteTapped() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}



