//
//  SettingsViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 12.08.2025.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .fill
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = UIColor.Color10
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ayarlar"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        return label
    }()

    private let switchScale: CGFloat = 0.7

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupContent()
        bindActions()
    }

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        contentStackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        contentStackView.addArrangedSubview(titleLabel)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(44)
        }
        contentStackView.setCustomSpacing(35, after: titleLabel)
    }

    // MARK: - Content
    private func setupContent() {
        let items: [(String, Selector)] = [
            ("Tarif Hatırlatma", #selector(onRecipeToggle(_:))),
            ("E‑posta Bildirimi Al", #selector(onEmailToggle(_:))),
            ("Alışveriş Hatırlatma", #selector(onShoppingToggle(_:)))
        ]

        for (title, action) in items {
            let toggle = makeSwitch(action: action)
            let row = makeSettingRow(title: title, toggle: toggle)
            contentStackView.addArrangedSubview(row)
        }
    }

    private func makeSettingRow(title: String, toggle: UISwitch) -> UIView {
        let card = UIView()
        applyCardStyle(card)

        card.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12

        let label = UILabel()
        label.text = title
        label.font = .dmSansSemiBold(14)
        label.textColor = UIColor.Text950
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        card.addSubview(row)
        row.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        row.addArrangedSubview(label)
        row.addArrangedSubview(toggle)

        return card
    }

    private func makeSwitch(action: Selector) -> UISwitch {
        let settingSwitch = UISwitch()
        settingSwitch.isOn = false
        settingSwitch.transform = CGAffineTransform(scaleX: switchScale, y: switchScale)
        settingSwitch.addTarget(self, action: action, for: .valueChanged)
        settingSwitch.onTintColor = UIColor.primaryColor
        settingSwitch.thumbTintColor = UIColor.textColor400

        settingSwitch.addAction(UIAction { _ in
            settingSwitch.thumbTintColor = settingSwitch.isOn ? .white : UIColor.textColor400
        }, for: .valueChanged)
        return settingSwitch
    }

    private func applyCardStyle(_ view: UIView) {
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Text50.cgColor
    }

    // MARK: - Actions
    private func bindActions() {
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func onRecipeToggle(_ sender: UISwitch) {
        print("Tarif Hatırlatma: \(sender.isOn ? "Açık" : "Kapalı")")
    }

    @objc private func onEmailToggle(_ sender: UISwitch) {
        print("E‑posta Bildirimi: \(sender.isOn ? "Açık" : "Kapalı")")
    }

    @objc private func onShoppingToggle(_ sender: UISwitch) {
        print("Alışveriş Hatırlatma: \(sender.isOn ? "Açık" : "Kapalı")")
    }
}
