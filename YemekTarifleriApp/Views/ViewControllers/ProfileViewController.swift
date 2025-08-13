//
//  ProfileViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    //MARK: - Properties
    private let viewModel = ProfileViewModel()
    private var currentUser: UserModel?

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
        stack.spacing = 25
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
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "bell")
        configuration.background.cornerRadius = 10
        configuration.baseBackgroundColor = .white
        button.configuration = configuration
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.07
        button.layer.masksToBounds = false
        button.addTarget(self,
                         action: #selector(navigateToNotification),
                         for: .touchUpInside)
        return button
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
        view.backgroundColor = UIColor.Text50
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.Text100.cgColor
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
        label.font = .dmSansSemiBold(17)
        label.textColor = UIColor.textColor900
        label.textAlignment = .left
        return label
    }()
    
    private lazy var editPreferenceButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        
        var attributedTitle = AttributedString("Profili Düzenle")
        attributedTitle.font = .dmSansSemiBold(11)
        attributedTitle.foregroundColor = UIColor.white
        configuration.attributedTitle = attributedTitle
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 11,
                                                              weight: .bold)
        configuration.image = UIImage(systemName: "square.and.pencil")?.withConfiguration(symbolConfiguration)
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3
        configuration.baseForegroundColor = UIColor.white
        configuration.baseBackgroundColor = UIColor.primaryColor

        configuration.background.cornerRadius = 20
        button.configuration = configuration
        button.addTarget(self,
                         action: #selector(navigateToEditProfile),
                         for: .touchUpInside)
        
        return button
    }()
    
    private lazy var dietLabel: UILabel = {
        let label = UILabel()
        label.text = "Beslenme tarzı: "
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private lazy var allergyLabel: UILabel = {
        let label = UILabel()
        label.text = "Alerji: "
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dontLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "Sevmediğim ürünler: "
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var optionsContainerStackView: UIStackView = {
        let shoppingList = ProfileOptionView(icon: UIImage(systemName: "cart"),
                                             title: "Alışveriş Listelerim")
        let settings = ProfileOptionView(icon: UIImage(systemName: "gearshape"),
                                         title: "Ayarlar")
        let language = ProfileOptionView(icon: UIImage(systemName: "globe"),
                                         title: "Dil Seçenekleri")
        let signOut = ProfileOptionView(icon: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                        title: "Çıkış Yap")

        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(signOutTapped))
        signOut.addGestureRecognizer(tapGesture)
        signOut.isUserInteractionEnabled = true
        
        let tapGestureSettings = UITapGestureRecognizer(target: self,
                                                        action: #selector(navigateToSettings))
        settings.addGestureRecognizer(tapGestureSettings)
        settings.isUserInteractionEnabled = true
        
        let stackView = UIStackView(arrangedSubviews: [
            makeDivider(color: UIColor.Text100),
            shoppingList,
            makeDivider(color: UIColor.Text100),
            settings,
            makeDivider(color: UIColor.Text100),
            language,
            makeDivider(color: UIColor.Text100),
            signOut,
            makeDivider(color: UIColor.Text100)
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
        view.addSubview(notificationButton)
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
            make.height.equalTo(44)
        }
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(44)
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
                self?.currentUser = user
                self?.profileNameLabel.text = user.displayName
                self?.emailLabel.text = user.email
                if let url = user.photoURL,
                   let Url = URL(string: url) {
                    self?.profileImageView.kf.setImage(with: Url)
                }
                
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
        
        viewModel.onSignOut = { [weak self] in
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                    return
                }
                
                let navigationController = UINavigationController(rootViewController: LoginRegisterViewController())
                navigationController.setNavigationBarHidden(true,
                                                            animated: false)
                
                sceneDelegate.window?.rootViewController = navigationController
                sceneDelegate.window?.makeKeyAndVisible()
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
    
    @objc private func signOutTapped() {
        let alert = LogoutAlertView()
        alert.onConfirm = { [weak self] in
            self?.viewModel.signOut()
        }
        alert.present(on: self)
    }
    
    @objc func navigateToEditProfile() {
        let viewModel = EditProfileViewModel(preloadedUser: currentUser)
        let editProfileViewController = EditProfileViewController(viewModel: viewModel)
        editProfileViewController.onDidSave = { [weak self] updatedUser in
            self?.currentUser = updatedUser
            self?.profileNameLabel.text = updatedUser.displayName
            self?.emailLabel.text = updatedUser.email
        }
        navigationController?.pushViewController(editProfileViewController,
                                                 animated: true)
    }
    
    @objc func navigateToSettings() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController,
                                                 animated: true)
    }
    
    @objc func navigateToNotification() {
        let notificationsViewController = NotificationsViewController()
        navigationController?.pushViewController(notificationsViewController,
                                                 animated: true)
    }
}



