//
//  ProfileViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit
import Kingfisher
import SwiftUI

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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        return stackView
    }()
    
    private lazy var myProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "My Profile"
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
        button.layer.shadowOffset = CGSize(width: 0,
                                           height: 1)
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
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.Text50.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let preferenceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var myPreferenceLabel: UILabel = {
        let label = UILabel()
        label.text = "My Preferences"
        label.font = .dmSansSemiBold(17)
        label.textColor = UIColor.textColor900
        label.textAlignment = .left
        return label
    }()
    
    private lazy var editPreferenceButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 13,
                                                              weight: .bold)
        configuration.image = UIImage(systemName: "square.and.pencil")?
            .withConfiguration(symbolConfiguration)
        
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
        label.text = "Diet: "
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private lazy var allergyLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(14)
        label.textColor = UIColor.Text950
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dontLikeLabel: UILabel = {
        let label = UILabel()
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
    
    private lazy var shoppingListOption: ProfileOptionView = {
        let view = ProfileOptionView(icon: UIImage(systemName: "cart"),
                                     title: "My Shopping Lists")
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(navigateToShoppingList))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var settingsOption: ProfileOptionView = {
        let view = ProfileOptionView(icon: UIImage(systemName: "gearshape"),
                                     title: "Settings")
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(navigateToSettings))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var passwordOption: ProfileOptionView = {
        let view = ProfileOptionView(icon: UIImage(systemName: "lock"),
                                     title: "Change Password")
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(navigateToChangePassword))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var emailOption: ProfileOptionView = {
        let view = ProfileOptionView(icon: UIImage(systemName: "envelope"),
                                     title: "Change Email")
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(navigateToChangeEmail))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var signOutOption: ProfileOptionView = {
        let view = ProfileOptionView(icon: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                     title: "Log Out")
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(signOutTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var optionsContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            shoppingListOption,
            settingsOption,
            passwordOption,
            emailOption,
            signOutOption
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.loadUserProfile()
        self.hideKeyboardOnTap()
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
            make.edges.equalToSuperview().inset(15)
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
            make.top.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        optionsView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        optionsContainerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onUserDataFetched = { [weak self] user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.profileNameLabel.text = "\(user.name ?? "") \(user.surname ?? "")"
                self?.emailLabel.text = user.email
                if let url = user.photoURL,
                   let Url = URL(string: url) {
                    self?.profileImageView.kf.setImage(with: Url)
                }
                self?.allergyLabel.text = "Allergy: \(user.allergies.joined(separator: ", "))"
                self?.dietLabel.text = "Diet: \(user.diet ?? "")"
                self?.dontLikeLabel.text = "Disliked Ingredients: \(user.dislikes.joined(separator: ", "))"
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
        
        viewModel.onSignOut = { 
            let loginViewController = LoginRegisterViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first {
                
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
    //MARK: - Actions
    @objc private func favoriteTapped() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    @objc private func signOutTapped() {
        let alert = CustomAlertView(titleText: "Do you want to log out?",
                                    confirmText: "Yes", cancelText: "No",
                                    isConfirmHidden: false)
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
            self?.profileNameLabel.text = "\(updatedUser.name ?? "") \(updatedUser.surname ?? "")"
            self?.emailLabel.text = updatedUser.email
            self?.profileImageView.kf.setImage(with: URL(string: updatedUser.photoURL ?? ""))
        }
        editProfileViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProfileViewController,
                                                 animated: true)
    }
    
    @objc func navigateToSettings() {
        let settingsViewController = SettingsViewController()
        settingsViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsViewController,
                                                 animated: true)
    }
    
    @objc func navigateToNotification() {
        let notificationsViewController = NotificationsViewController()
        notificationsViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notificationsViewController,
                                                 animated: true)
    }
    
    @objc func navigateToChangePassword() {
        let changePasswordViewController = ChangePasswordViewController()
        changePasswordViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(changePasswordViewController,
                                                 animated: true)
    }
    
    @objc func navigateToChangeEmail() {
        let changeEmailViewController = ChangeEmailViewController()
        changeEmailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(changeEmailViewController,
                                                 animated: true)
    }
    
    @objc func navigateToShoppingList() {
        let hostingController = UIHostingController(rootView: ShoppingListView())
        hostingController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingController,
                                                 animated: true)
    }
}



