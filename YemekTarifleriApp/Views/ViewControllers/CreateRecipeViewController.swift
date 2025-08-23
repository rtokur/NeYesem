//
//  CreateRecipeViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import UIKit

class CreateRecipeViewController: UIViewController {
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Recipe"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.Color10
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let fridgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Text100.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let prepareView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Text100.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Recipe", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .dmSansBold(16)
        button.layer.cornerRadius = 15
        button.addTarget(self,
                         action: #selector(createButtonAction),
                         for: .touchUpInside)
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
        stackView.addArrangedSubview(titleLabel)
        titleLabel.addSubview(backButton)
        stackView.addArrangedSubview(fridgeView)
        stackView.addArrangedSubview(prepareView)
        stackView.addArrangedSubview(createButton)
    }
    
    func setupConstraints(){
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        fridgeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(215)
        }
        prepareView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(130)
        }
        createButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    //MARK: - Actions
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func createButtonAction() {
        let loadingViewController = LoadingViewController()
        navigationController?.pushViewController(loadingViewController, animated: true)
    }
    
}
