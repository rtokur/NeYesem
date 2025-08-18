//
//  ChangeEmailViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 18.08.2025.
//

import UIKit

class ChangeEmailViewController: UIViewController {
    private var activeTextField: UITextField?
    private let viewModel = ChangeEmailViewModel()
    private var passwordToggleButtons: [UITextField: UIButton] = [:]

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
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"),
                        for: .normal)
        button.tintColor = UIColor.Color10
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var editProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "E posta Değiştirme"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var editFormStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    private lazy var currentEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Mevcut E posta"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        label.textAlignment = .left
        return label
    }()

    private lazy var currentEmailTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .emailAddress
        textField.applyDefaultStyle(placeholder: "ornek@hotmail.com")
        return textField
    }()
    
    private lazy var currentPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Mevcut şifre"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        label.textAlignment = .left
        return label
    }()

    private lazy var currentPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.applyDefaultStyle(placeholder: "***********")
        return textField
    }()
    
    private lazy var newEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Yeni E posta"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        label.textAlignment = .left
        return label
    }()

    private lazy var newEmailTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .emailAddress
        textField.applyDefaultStyle(placeholder: "Yeni E posta")
        return textField
    }()
    
    private lazy var confirmEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "E postayı doğrula"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        label.textAlignment = .left
        return label
    }()

    private lazy var confirmEmailTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .emailAddress
        textField.applyDefaultStyle(placeholder: "Yeni E postayı doğrulama")
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.addTarget(self,
                         action: #selector(saveTapped),
                         for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupDelegates()
        setupReturnKeys()
        setupKeyboardObservers()
        
        bindViewModel()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(editProfileLabel)
        stackView.addArrangedSubview(editFormStackView)
        editFormStackView.addArrangedSubview(currentEmailLabel)
        editFormStackView.addArrangedSubview(currentEmailTextField)
        editFormStackView.addArrangedSubview(currentPasswordLabel)
        editFormStackView.addArrangedSubview(currentPasswordTextField)
        addPasswordToggleButton(to: currentPasswordTextField)
        editFormStackView.addArrangedSubview(newEmailLabel)
        editFormStackView.addArrangedSubview(newEmailTextField)
        editFormStackView.addArrangedSubview(confirmEmailLabel)
        editFormStackView.addArrangedSubview(confirmEmailTextField)
        stackView.addArrangedSubview(saveButton)
        view.addSubview(backButton)
        self.hideKeyboardOnTap()
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        editProfileLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        editFormStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        currentEmailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        currentPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        newEmailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        confirmEmailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    
    private func setupDelegates(){
        currentEmailTextField.delegate = self
        currentPasswordTextField.delegate = self
        newEmailTextField.delegate = self
        confirmEmailTextField.delegate = self
    }
    
    private func setupReturnKeys() {
        currentEmailTextField.returnKeyType = .next
        currentPasswordTextField.returnKeyType = .next
        newEmailTextField.returnKeyType = .next
        confirmEmailTextField.returnKeyType = .done
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
    
    private func bindViewModel() {
        currentEmailTextField.text = viewModel.currentEmail
        viewModel.onSuccess = { [weak self] result in
            guard let result = result else {
                let successChangingViewController = SuccessChangingViewController()
                self?.navigationController?.pushViewController(successChangingViewController, animated: true)
                return
            }
            let successChangingViewController = SuccessChangingViewController()
            successChangingViewController.successMessage = result
            self?.navigationController?.pushViewController(successChangingViewController, animated: true)
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Hata", message: message)
            }
        }
    }

    private func addPasswordToggleButton(to textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = UIColor.textColor300
        button.frame = CGRect(x: -10, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchDown)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
        containerView.addSubview(button)
        
        textField.rightView = containerView
        textField.rightViewMode = .always
        
        passwordToggleButtons[textField] = button
    }
    
    //MARK: Actions
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
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        guard let (textField, _) = passwordToggleButtons.first(where: { $0.value == sender }) else { return }
        
        textField.isSecureTextEntry.toggle()
        
        let imageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
        UIView.transition(with: sender,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            sender.setImage(UIImage(systemName: imageName), for: .normal)
        })
    }
    
    @objc private func saveTapped() {
        viewModel.changeEmail(
            current: currentEmailTextField.text,
            password: currentPasswordTextField.text,
            new: newEmailTextField.text,
            confirm: confirmEmailTextField.text
        )
    }
}

extension ChangeEmailViewController: UITextFieldDelegate  {
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
            
        case currentEmailTextField:
            currentPasswordTextField.becomeFirstResponder()
        case currentPasswordTextField:
            newEmailTextField.becomeFirstResponder()
        case newEmailTextField:
            confirmEmailTextField.becomeFirstResponder()
        case confirmEmailTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
