//
//  SuccessChangingViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 18.08.2025.
//

import UIKit

class SuccessChangingViewController: UIViewController {
    //MARK: Properties
    var successMessage: String?
    private let viewModel = ProfileViewModel()
    
    //MARK: UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 60
        return stackView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        button.addTarget(self,
                         action: #selector(backButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "Password Successfully Changed"
        label.font = .dmSansBold(18)
        label.textColor = UIColor.Primary950
        label.textAlignment = .center
        return label
    }()

    private lazy var successLabel2: UILabel = {
        let label = UILabel()
        label.text = "You can now log in with your new password."
        label.font = .dmSansRegular(14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.textColor400
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.addTarget(self,
                         action: #selector(loginTapped),
                         for: .touchUpInside)
        button.layer.cornerRadius = 15
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
        stackView.addArrangedSubview(successImageView)
        stackView.addArrangedSubview(successLabel)
        stackView.addArrangedSubview(successLabel2)
        stackView.addArrangedSubview(loginButton)
        stackView.setCustomSpacing(10, after: successLabel)
        view.addSubview(backButton)
        
        if let successMessage = successMessage {
            successLabel.text = "Verification Link Sent"
            successLabel2.text = successMessage
        }
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(90)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        successImageView.snp.makeConstraints { make in
            make.height.width.equalTo(130)
        }
        successLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        successLabel2.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func loginTapped() {
        viewModel.signOut()
            
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
