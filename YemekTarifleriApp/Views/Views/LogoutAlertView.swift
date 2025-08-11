//
//  CustomAlert.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 10.08.2025.
//

import UIKit

final class LogoutAlertView: UIView {

    // MARK: - Callbacks
    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI Elements
    private let backgroundView: UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addTarget(self, action: #selector(handleBackgroundTap), for: .touchUpInside)
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .dmSansRegular(16)
        label.textColor = .black
        label.text = "Çıkış yapmak istiyor musunuz?"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Evet", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.primaryColor, for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.layer.borderColor = UIColor.primaryColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.addTarget(self,
                         action: #selector(handleConfirm),
                         for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Hayır", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.layer.cornerRadius = 15
        button.addTarget(self,
                         action: #selector(handleCancel),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Setup Methods
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(confirmButton)
        buttonsStackView.addArrangedSubview(cancelButton)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(30)
        }
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
    }
    
    // MARK: - Functions
    func present(on viewController: UIViewController) {
        guard let host = viewController.view else { return }
        host.addSubview(backgroundView)
        backgroundView.addSubview(self)

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(302)
            make.height.equalTo(179)
        }

        backgroundView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9,
                                                    y: 0.9)
        UIView.animate(withDuration: 0.22) { self.backgroundView.alpha = 1 }
        UIView.animate(withDuration: 0.24,
                       delay: 0.02,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.8) {
            self.containerView.transform = .identity
        }

        UIAccessibility.post(notification: .screenChanged, argument: titleLabel)
    }

    func dismiss(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2,
                       animations: {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.92,
                                                             y: 0.92)
        }, completion: { _ in
            self.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            completion?()
        })
    }

    // MARK: - Actions
    @objc private func handleBackgroundTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss { [weak self] in self?.onCancel?() }
    }
    
    @objc private func handleCancel() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss { [weak self] in self?.onCancel?() }
    }
    
    @objc private func handleConfirm() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        dismiss { [weak self] in self?.onConfirm?() }
    }
}
