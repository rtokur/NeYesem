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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 25
        return stackView
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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.textColor = UIColor.Primary950
        label.font = UIFont.dmSansSemiBold(22)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your registered email address to receive a password reset link."
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor400
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor.textColor800
        label.font = UIFont.dmSansRegular(16)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.applyDefaultStyle(placeholder: "example@hotmail.com")
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send",
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
                    guard let self = self else { return }
                    let alert = CustomAlertView(
                        titleText: error,
                        confirmText: "",
                        cancelText: "OK",
                        isConfirmHidden: true
                    )
                    
                    alert.present(on: self)
                } else {
                    guard let self = self else { return }
                    let alert = CustomAlertView(
                        titleText: "A password reset link has been sent to your email address.",
                        confirmText: "",
                        cancelText: "OK",
                        isConfirmHidden: true
                    )
                    
                    alert.onCancel = { [weak alert] in
                        alert?.dismiss()
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.present(on: self)
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

//MARK: - Delegates
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
