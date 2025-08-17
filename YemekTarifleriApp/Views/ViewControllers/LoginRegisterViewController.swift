//
//  ViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.07.2025.
//

import UIKit
import SnapKit
import SwiftUI

class LoginRegisterViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    private var passwordToggleButtons: [(UITextField, UIButton)] = []
    private var activeTextField: UITextField?
    private let loginRegisterViewModel = LoginRegisterViewModel()

    //MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        return stackView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Giriş Yap",
                                                          "Kayıt Ol"])
        segmentedControl.selectedSegmentIndex = 0
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryColor,
            .font: UIFont.dmSansSemiBold(16)
        ]
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textColor500,
            .font: UIFont.dmSansSemiBold(16)
        ]
        
        segmentedControl.setTitleTextAttributes(normalAttributes,
                                                for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes,
                                                for: .selected)
        
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedControlClicked(_:)),
                                   for: .valueChanged)
        
        return segmentedControl
    }()
    
    private let loginView: UIView = {
        let view = UIView()
        view.isHidden = false
        return view
    }()
    
    private lazy var loginFormStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-posta"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.applyDefaultStyle(placeholder: "ornek@hotmail.com")
        return textField
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifre"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.applyDefaultStyle(placeholder: "***********")
        return textField
    }()

    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        let text = "Şifreni mi unuttun?"
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(.underlineStyle,
                                value: NSUnderlineStyle.single.rawValue,
                                range: NSRange(location: 0,
                                               length: text.count))
        attributed.addAttribute(.foregroundColor,
                                value: UIColor.secondaryColor,
                                range: NSRange(location: 0,
                                               length: text.count))
        label.attributedText = attributed
        label.font = UIFont.dmSansRegular(14)
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.dmSansBold(16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let signUpView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var signUpFormStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var emailSignUpLabel: UILabel = {
        let label = UILabel()
        label.text = "E-posta"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        return label
    }()

    private lazy var emailSignUpTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.applyDefaultStyle(placeholder: "ornek@hotmail.com")
        return textField
    }()

    private lazy var newPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Yeni Şifre"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        return label
    }()

    private lazy var newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.applyDefaultStyle(placeholder: "***********")
        return textField
    }()

    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifreyi Doğrula"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        return label
    }()

    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.applyDefaultStyle(placeholder: "***********")
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.dmSansBold(16)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private lazy var orLineStack: UIStackView = {
        let leftLine = makeLineView()
        let rightLine = makeLineView()
        let label = makeLabel("ya da",
                              fontSize: 14,
                              color: UIColor.textColor400)
        let stack = UIStackView(arrangedSubviews: [leftLine,
                                                   label,
                                                   rightLine])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private lazy var socialButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [facebookButton,
                                                   googleButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var googleButton: UIButton = {
        let button = makeSocialButton(imageName: "google-icon")
        button.addTarget(self,
                         action: #selector(handleGoogleLogin),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var facebookButton: UIButton = {
        let button = makeSocialButton(imageName: "facebook-icon")
        button.addTarget(self,
                         action: #selector(handleFacebookLogin),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    private lazy var bottomTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesabın yok mu?"
        label.font = UIFont.dmSansRegular(14)
        label.textColor = .darkGray
        return label
    }()

    private lazy var signUpLoginLabel: UILabel = {
        let label = UILabel()
        let text = "Kayıt Ol"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0,
                                                     length: text.count))
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.secondaryColor,
                                      range: NSRange(location: 0,
                                                     length: text.count))
        label.attributedText = attributedString
        label.font = UIFont.dmSansRegular(14)
        label.isUserInteractionEnabled = true
        return label
    }()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGestures()
        setupPasswordTextField()
        setupDelegates()
        setupReturnKeys()
        setupKeyboardObservers()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(loginView)
        loginView.addSubview(loginFormStackView)
        loginFormStackView.addArrangedSubview(emailLabel)
        loginFormStackView.addArrangedSubview(emailTextField)
        loginFormStackView.addArrangedSubview(passwordLabel)
        loginFormStackView.addArrangedSubview(passwordTextField)
        loginFormStackView.addArrangedSubview(forgotPasswordLabel)
        loginFormStackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(signUpView)
        signUpView.addSubview(signUpFormStackView)
        signUpFormStackView.addArrangedSubview(emailSignUpLabel)
        signUpFormStackView.addArrangedSubview(emailSignUpTextField)
        signUpFormStackView.addArrangedSubview(newPasswordLabel)
        signUpFormStackView.addArrangedSubview(newPasswordTextField)
        signUpFormStackView.addArrangedSubview(confirmPasswordLabel)
        signUpFormStackView.addArrangedSubview(confirmPasswordTextField)
        signUpFormStackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(orLineStack)
        stackView.addArrangedSubview(socialButtonsStack)
        bottomStack.addArrangedSubview(bottomTextLabel)
        bottomStack.addArrangedSubview(signUpLoginLabel)
        stackView.addArrangedSubview(bottomStack)
        
        self.hideKeyboardOnTap()
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        segmentedControl.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        loginView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
        loginFormStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        signUpView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(370)
        }
        signUpFormStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        emailSignUpTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        newPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        orLineStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
        }
        if let leftLine = orLineStack.arrangedSubviews.first,
           let label = orLineStack.arrangedSubviews[1] as? UILabel,
           let rightLine = orLineStack.arrangedSubviews.last {
            
            leftLine.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
            
            label.snp.makeConstraints { make in
                make.height.equalTo(16)
            }
            
            rightLine.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.width.equalTo(leftLine)
            }
        }
        socialButtonsStack.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(116)
        }
        for button in socialButtonsStack.arrangedSubviews {
            button.snp.makeConstraints { make in
                make.width.equalTo(50)
            }
        }
        bottomStack.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    private func setupGestures() {
        let tapGestureSignUp = UITapGestureRecognizer(target: self,
                                                      action: #selector(signUpLoginTapped))
        signUpLoginLabel.addGestureRecognizer(tapGestureSignUp)
        let tapGestureForgotPassword = UITapGestureRecognizer(target: self,
                                                              action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(tapGestureForgotPassword)
    }

    private func setupDelegates(){
        emailTextField.delegate = self
        emailSignUpTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
    }
    
    private func setupReturnKeys() {
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
        emailSignUpTextField.returnKeyType = .next
        newPasswordTextField.returnKeyType = .next
        confirmPasswordTextField.returnKeyType = .done
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
    //MARK: - Functions
    private func updateSignUpLoginLabel(text: String) {
        let attributes = NSMutableAttributedString(string: text)
        attributes.addAttribute(.underlineStyle,
                          value: NSUnderlineStyle.single.rawValue,
                          range: NSRange(location: 0,
                                         length: text.count))
        attributes.addAttribute(.foregroundColor,
                          value: UIColor.secondaryColor,
                          range: NSRange(location: 0,
                                         length: text.count))
        signUpLoginLabel.attributedText = attributes
    }
    
    private func makeSocialButton(imageName: String? = nil,
                                  systemName: String? = nil) -> UIButton {
        let button = UIButton()
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName),
                            for: .normal)
        } else if let systemName = systemName {
            button.setImage(UIImage(systemName: systemName),
                            for: .normal)
            button.tintColor = .black
        }
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.D8DADC.cgColor
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0,
                                           height: 2)
        button.layer.shadowRadius = 4
        return button
    }
    
    private func makeLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.textColor400
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }
    
    private func makeLabel(_ text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.dmSansRegular(fontSize)
        label.textColor = color
        label.textAlignment = .center
        return label
    }

    private func setupPasswordTextField() {
        addPasswordToggleButton(to: passwordTextField)
        addPasswordToggleButton(to: confirmPasswordTextField)
        addPasswordToggleButton(to: newPasswordTextField)
    }
    
    private func addPasswordToggleButton(to textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"),
                        for: .normal)
        button.tintColor = UIColor.textColor300
        button.frame = CGRect(x: -10,
                              y: 0,
                              width: 24,
                              height: 24)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchDown)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
        containerView.addSubview(button)

        textField.rightView = containerView
        textField.rightViewMode = .always

        passwordToggleButtons.append((textField, button))
    }
    
    private func navigateToHome() {
        let dietSelectionViewController = DietSelectionViewController()
        navigationController?.pushViewController(dietSelectionViewController, animated: true)
    }
    
    // MARK: - Actions
    @objc func segmentedControlClicked(_ sender: UISegmentedControl) {
        loginView.isHidden = sender.selectedSegmentIndex == 1
        signUpView.isHidden = sender.selectedSegmentIndex == 0
        
        bottomTextLabel.text = sender.selectedSegmentIndex == 0 ? "Hesabın yok mu?" : "Zaten bir hesabın var mı?"
        updateSignUpLoginLabel(text: sender.selectedSegmentIndex == 0 ? "Kayıt Ol" : "Giriş Yap")
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        guard let (textField, _) = passwordToggleButtons.first(where: { $0.1 == sender }) else { return }
        
        textField.isSecureTextEntry.toggle()

        let imageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
        
        UIView.transition(with: sender,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            sender.setImage(UIImage(systemName: imageName), for: .normal)
        })
    }
    
    @objc private func signUpLoginTapped() {
        segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex == 0 ? 1 : 0
        segmentedControlClicked(segmentedControl)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset.bottom = keyboardHeight + 20
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 20
            
            if let activeTextField = activeTextField {
                let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: scrollView)
                scrollView.scrollRectToVisible(textFieldFrame, animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func handleLogin(){
        loginRegisterViewModel.login(email: emailTextField.text, password: passwordTextField.text) { [weak self] error in
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.navigateToHome()
            }
        }
    }
    
    @objc private func handleRegister(){
        loginRegisterViewModel.register(email: emailSignUpTextField.text, password: newPasswordTextField.text, confirmPassword: confirmPasswordTextField.text) { [weak self] error in
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.navigateToHome()
            }
        }
    }
    
    @objc private func forgotPasswordTapped(){
        let forgotPasswordViewController = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordViewController,
                                                 animated: true)
    }
    
    @objc private func handleGoogleLogin() {
        loginRegisterViewModel.loginWithGoogle(presentingVC: self) { [weak self] error in
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.navigateToHome()
            }
        }
    }
    
    @objc private func handleFacebookLogin() {
        loginRegisterViewModel.loginWithFacebook(presentingVC: self) { [weak self] error in
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.navigateToHome()
            }
        }
    }
}

//MARK: - Delegates
extension LoginRegisterViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        textField.setActiveBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
        textField.setInactiveBorder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
            
        case emailSignUpTextField:
            newPasswordTextField.becomeFirstResponder()
        case newPasswordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
