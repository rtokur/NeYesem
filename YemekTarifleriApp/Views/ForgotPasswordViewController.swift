//
//  ForgotPasswordViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    private let forgotPasswordViewModel = ForgotPasswordViewModel()
    
    //MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 25
        return stack
    }()
    
    private lazy var backButtonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        button.addTarget(self,
                         action: #selector(backTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifremi Unuttum"
        label.textColor = UIColor.Primary950
        label.font = UIFont.dmSansSemiBold(22)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifrenizi yenileme linkini gönderebileceğimiz kayıtlı mail adresinizi yazınız."
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor400
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-posta"
        label.textColor = UIColor.textColor800
        label.font = UIFont.dmSansRegular(16)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.applyDefaultStyle(placeholder: "ornek@hotmail.com")
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Gönder",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.dmSansBold(16)
        button.addTarget(self,
                         action: #selector(sendTapped),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupKeyboardObservers()
        hideKeyboardOnTap()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(backButtonContainer)
        backButtonContainer.addSubview(backButton)
        mainStackView.addArrangedSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(emailLabel)
        contentStackView.addArrangedSubview(emailTextField)
        emailTextField.delegate = self
        contentStackView.addArrangedSubview(sendButton)
        contentStackView.setCustomSpacing(50,
                                          after: descriptionLabel)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        mainStackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        backButtonContainer.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: - Actions
    @objc func backTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sendTapped(){
        forgotPasswordViewModel.resetPassword(email: emailTextField.text) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Hata", message: error)
                } else {
                    self?.showAlert(title: "Başarılı", message: "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.")
                }
            }
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset.bottom = keyboardHeight + 20
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 20
            
            let textFieldFrame = emailTextField.convert(emailTextField.bounds,
                                                        to: scrollView)
            scrollView.scrollRectToVisible(textFieldFrame,
                                           animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

extension ForgotPasswordViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setActiveBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setInactiveBorder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
