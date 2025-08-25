//
//  EditProfileViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 10.08.2025.
//

import UIKit
import Photos

class EditProfileViewController: UIViewController{
    //MARK: Properties
    private let viewModel: EditProfileViewModel
    private var passwordToggleButton: (UITextField, UIButton)?
    private var activeTextField: UITextField?
    var onDidSave: ((UserModel) -> Void)?
    
    //MARK: UI Elements
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
        label.text = "Edit Profile"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
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
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.primaryColor
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "camera.fill"),
                        for: .normal)
        button.clipsToBounds = true
        button.addTarget(self,
                         action: #selector(cameraButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var editFormStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "First Name"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.applyDefaultStyle(placeholder: "First Name")
        return textField
    }()

    private lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Last Name"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        return label
    }()

    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.applyDefaultStyle(placeholder: "Last Name")
        return textField
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.font = UIFont.dmSansRegular(16)
        label.textColor = UIColor.textColor800
        label.textAlignment = .left
        return label
    }()

    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .telephoneNumber
        textField.applyDefaultStyle(placeholder: "Phone Number")
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
    
    //MARK: - Init
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupDelegates()
        setupReturnKeys()
        setupKeyboardObservers()
        
        bindViewModel()
        viewModel.load()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(editProfileLabel)
        editProfileLabel.addSubview(backButton)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(editFormStackView)
        editFormStackView.addArrangedSubview(nameLabel)
        editFormStackView.addArrangedSubview(nameTextField)
        editFormStackView.addArrangedSubview(surnameLabel)
        editFormStackView.addArrangedSubview(surnameTextField)
        editFormStackView.addArrangedSubview(phoneLabel)
        editFormStackView.addArrangedSubview(phoneTextField)
        stackView.addArrangedSubview(saveButton)
        view.addSubview(cameraButton)
        self.hideKeyboardOnTap()
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        editProfileLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(120)
        }
        cameraButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.trailing.equalToSuperview().inset(150)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(140)
        }
        editFormStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        surnameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    private func setupDelegates(){
        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    private func setupReturnKeys() {
        nameTextField.returnKeyType = .next
        surnameTextField.returnKeyType = .next
        phoneTextField.returnKeyType = .done
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
        viewModel.onLoaded = { [weak self] user in
            DispatchQueue.main.async {
                self?.nameTextField.text = user.name ?? ""
                self?.surnameTextField.text = user.surname ?? ""
                self?.phoneTextField.text = user.phone ?? ""
                if let url = user.photoURL,
                   let Url = URL(string: url) {
                    self?.profileImageView.kf.setImage(with: Url)
                }
            }
        }
        viewModel.onSaved = { updated in
            DispatchQueue.main.async {
                self.onDidSave?(updated)
                
                let alert = CustomAlertView(
                    titleText: "Your profile information has been successfully updated",
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
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async { self?.showAlert(title: "Error",
                                                       message: message) }
        }
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
        button.addTarget(self,
                         action: #selector(togglePasswordVisibility(_:)),
                         for: .touchDown)

        let containerView = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: 34,
                                                 height: 24))
        containerView.addSubview(button)

        textField.rightView = containerView
        textField.rightViewMode = .always

        passwordToggleButton = (textField, button)
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.openImagePicker(sourceType: .camera)
                } else {
                    self.showPermissionAlert(type: "Camera")
                }
            }
        }
    }

    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self.openImagePicker(sourceType: .photoLibrary)
                } else {
                    self.showPermissionAlert(type: "Photo Library")
                }
            }
        }
    }
    
    private func showPermissionAlert(type: String) {
        let alert = UIAlertController(title: "\(type.capitalized) access required",
                                      message: "Please enable \(type) access in Settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))
        present(alert, animated: true)
    }

    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //MARK: - Actions
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
        guard let (textField, _) = passwordToggleButton else { return }
        
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
        viewModel.save(
            name: nameTextField.text,
            surname: surnameTextField.text,
            phone: phoneTextField.text,
            image: profileImageView.image
        )
    }
    
    @objc private func cameraButtonTapped() {
        let alert = UIAlertController(title: "Add Photo",
                                      message: nil,
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Camera",
                                      style: .default,
                                      handler: { _ in
            self.requestCameraAccess()
        }))

        alert.addAction(UIAlertAction(title: "Photo Library",
                                      style: .default,
                                      handler: { _ in
            self.requestPhotoLibraryAccess()
        }))

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))

        present(alert, animated: true)
    }
}


// MARK: - Delegates
extension EditProfileViewController: UITextFieldDelegate  {
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
            
        case nameTextField:
            surnameTextField.becomeFirstResponder()
        case surnameTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
    }
}
