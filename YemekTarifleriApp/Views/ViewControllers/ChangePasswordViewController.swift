//
//  ChangePasswordViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 18.08.2025.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    //MARK: Properties
    private var passwordToggleButtons: [UITextField: UIButton] = [:]
    private var activeTextField: UITextField?
    private let viewModel = ChangePasswordViewModel()

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
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var editProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Password"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
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
    
    private lazy var editFormStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    private lazy var currentPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Password"
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
    
    private lazy var newPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "New Password"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        label.textAlignment = .left
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
        label.text = "Confirm Password"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        label.textAlignment = .left
        return label
    }()

    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.applyDefaultStyle(placeholder: "***********")
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
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
        editFormStackView.addArrangedSubview(currentPasswordLabel)
        editFormStackView.addArrangedSubview(currentPasswordTextField)
        editFormStackView.addArrangedSubview(newPasswordLabel)
        editFormStackView.addArrangedSubview(newPasswordTextField)
        editFormStackView.addArrangedSubview(confirmPasswordLabel)
        editFormStackView.addArrangedSubview(confirmPasswordTextField)
        addPasswordToggleButton(to: currentPasswordTextField)
        addPasswordToggleButton(to: newPasswordTextField)
        addPasswordToggleButton(to: confirmPasswordTextField)
        stackView.addArrangedSubview(saveButton)
        editProfileLabel.addSubview(backButton)
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
        editProfileLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        editFormStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        currentPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        newPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    
    private func setupDelegates(){
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func setupReturnKeys() {
        currentPasswordTextField.returnKeyType = .next
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
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            let successChangingViewController = SuccessChangingViewController()
            self?.navigationController?.pushViewController(successChangingViewController,
                                                           animated: true)
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Hata",
                                message: message)
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
                let textFieldFrame = activeTextField.convert(activeTextField.bounds,
                                                             to: scrollView)
                scrollView.scrollRectToVisible(textFieldFrame,
                                               animated: true)
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
            sender.setImage(UIImage(systemName: imageName),
                            for: .normal)
        })
    }
    
    @objc private func saveTapped() {
        viewModel.changePassword(
            current: currentPasswordTextField.text,
            new: newPasswordTextField.text,
            confirm: confirmPasswordTextField.text
        )
    }
}

// MARK: - Delegates
extension ChangePasswordViewController: UITextFieldDelegate  {
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
            
        case currentPasswordTextField:
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
