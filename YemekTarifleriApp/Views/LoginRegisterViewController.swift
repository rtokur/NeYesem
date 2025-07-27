//
//  ViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.07.2025.
//

import UIKit
import SnapKit

class LoginRegisterViewController: UIViewController {
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
        imageView.backgroundColor = .blue
        return imageView
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Giriş Yap",
                                                          "Kayıt Ol"])
        segmentedControl.selectedSegmentIndex = 0
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "CustomSecondaryColor") ?? .systemBlue,
            .font: UIFont(name: "DMSans-SemiBold",
                          size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ]
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "Text500") ?? .gray,
            .font: UIFont(name: "DMSans-SemiBold",
                          size: 16) ?? UIFont.systemFont(ofSize: 16)
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
    
    private lazy var loginFormStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-posta"
        label.font = UIFont(name: "DMSans-Regular",
                            size: 16)
        label.textColor = UIColor(named: "Text800")
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor(named: "Text300")?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        
        let font = UIFont(name: "DMSans-Regular",
                          size: 16)
        let textColor = UIColor(named: "Text900")
        
        textField.font = font
        textField.textColor = textColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "ornek@hotmail.com",
            attributes: [
                .foregroundColor: UIColor(named: "Text300") ?? UIColor.lightGray,
                .font: font ?? .systemFont(ofSize: 16)
            ]
        )
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 17,
                                               height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Şifre"
        label.font = UIFont(name: "DMSans-Regular",
                            size: 16)
        label.textColor = UIColor(named: "Text800")
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor(named: "Text300")?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        
        let font = UIFont(name: "DMSans-Regular", size: 16)
        let textColor = UIColor(named: "Text900")
        
        textField.font = font
        textField.textColor = textColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "***********",
            attributes: [
                .foregroundColor: UIColor(named: "Text300") ?? UIColor.lightGray,
                .font: font ?? .systemFont(ofSize: 16)
            ]
        )
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 17,
                                               height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
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
                                value: UIColor(named: "CustomSecondaryColor") ?? .systemBlue,
                                range: NSRange(location: 0,
                                               length: text.count))
        label.attributedText = attributed
        label.font = UIFont(name: "DMSans-Regular",
                            size: 14)
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
        button.backgroundColor = UIColor(named: "CustomPrimaryColor")
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont(name: "DMSans-Bold",
                                         size: 16)
        return button
    }()
    
    private let signUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.isHidden = true
        return view
    }()
    
    private lazy var orLineStack: UIStackView = {
        let leftLine = makeLineView()
        let rightLine = makeLineView()
        let label = makeLabel("ya da",
                              fontSize: 14,
                              color: UIColor(named: "Text400") ?? .lightGray)
        let stack = UIStackView(arrangedSubviews: [leftLine,
                                                   label,
                                                   rightLine])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private lazy var socialButtonsStack: UIStackView = {
        let fbButton = makeSocialButton(imageName: "facebook-icon")
        let googleButton = makeSocialButton(imageName: "google-icon")
        let appleButton = makeSocialButton(systemName: "apple.logo")
        let stack = UIStackView(arrangedSubviews: [fbButton,
                                                   googleButton,
                                                   appleButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .equalSpacing
        return stack
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
        label.font = UIFont(name: "DMSans-Regular",
                            size: 14)
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
                                      value: UIColor(named: "CustomSecondaryColor") ?? UIColor.orange,
                                      range: NSRange(location: 0,
                                                     length: text.count))
        label.attributedText = attributedString
        label.font = UIFont(name: "DMSans-Regular",
                            size: 14)
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
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(loginView)
        loginView.addSubview(loginFormStack)
        loginFormStack.addArrangedSubview(emailLabel)
        loginFormStack.addArrangedSubview(emailTextField)
        loginFormStack.addArrangedSubview(passwordLabel)
        loginFormStack.addArrangedSubview(passwordTextField)
        loginFormStack.addArrangedSubview(forgotPasswordLabel)
        loginFormStack.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(signUpView)
        stackView.addArrangedSubview(orLineStack)
        stackView.addArrangedSubview(socialButtonsStack)
        bottomStack.addArrangedSubview(bottomTextLabel)
        bottomStack.addArrangedSubview(signUpLoginLabel)
        stackView.addArrangedSubview(bottomStack)
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
        loginFormStack.snp.makeConstraints { make in
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
            make.height.equalTo(400)
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
            make.leading.trailing.equalToSuperview().inset(100)
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
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(signUpLoginTapped))
        signUpLoginLabel.addGestureRecognizer(tapGesture)
    }
        
    //MARK: - Functions
    private func updateSignUpLoginLabel(text: String) {
        let attr = NSMutableAttributedString(string: text)
        attr.addAttribute(.underlineStyle,
                          value: NSUnderlineStyle.single.rawValue,
                          range: NSRange(location: 0,
                                         length: text.count))
        attr.addAttribute(.foregroundColor,
                          value: UIColor(named: "CustomSecondaryColor") ?? UIColor.orange,
                          range: NSRange(location: 0,
                                         length: text.count))
        signUpLoginLabel.attributedText = attr
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
        button.layer.borderColor = UIColor(named: "D8DADC")?.cgColor
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
        view.backgroundColor = UIColor(named: "Text400")
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }
    
    private func makeLabel(_ text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "DMSans-Regular",
                            size: fontSize)
        label.textColor = color
        label.textAlignment = .center
        return label
    }

    private func setupPasswordTextField() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"),
                        for: .normal)
        button.tintColor = UIColor(named: "Text300") ?? .gray
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 30,
                              height: 30)
        button.addTarget(self,
                         action: #selector(togglePasswordVisibility),
                         for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: 34,
                                                 height: 24))
        button.frame = CGRect(x: -10,
                              y: 0,
                              width: 24,
                              height: 24)
        containerView.addSubview(button)
        
        passwordTextField.rightView = containerView
        passwordTextField.rightViewMode = .always
    }
    
    // MARK: - Actions
    @objc func segmentedControlClicked(_ sender: UISegmentedControl) {
        loginView.isHidden = sender.selectedSegmentIndex == 1
        signUpView.isHidden = sender.selectedSegmentIndex == 0
        
        bottomTextLabel.text = sender.selectedSegmentIndex == 0 ? "Hesabın yok mu?" : "Zaten bir hesabın var mı?"
        updateSignUpLoginLabel(text: sender.selectedSegmentIndex == 0 ? "Kayıt Ol" : "Giriş Yap")
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        UIView.transition(with: sender,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            let imageName = self.passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
            sender.setImage(UIImage(systemName: imageName),
                            for: .normal)
        })
    }
    
    @objc private func signUpLoginTapped() {
        segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex == 0 ? 1 : 0
        segmentedControlClicked(segmentedControl)
    }
    
}

