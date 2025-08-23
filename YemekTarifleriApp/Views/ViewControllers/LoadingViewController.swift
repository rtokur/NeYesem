//
//  LoadingViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 22.08.2025.
//

import UIKit

class LoadingViewController: UIViewController {

    //MARK: UI Elements
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 137
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preparing your recipe…"
        label.font = .dmSansSemiBold(18)
        label.textColor = UIColor.textColor900
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "This may take a few seconds..."
        label.font = .dmSansRegular(14, weight: .thin)
        label.textColor = UIColor.Text600
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var waitLabel: UILabel = {
        let label = UILabel()
        label.text = "Please wait."
        label.font = .dmSansRegular(14, weight: .thin)
        label.textColor = UIColor.Text600
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGIF()
    }

    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = UIColor.Text50
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(loadingLabel)
        stackView.addArrangedSubview(waitLabel)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(370)
        }
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(274)
        }
    }
    
    func setupGIF() {
        if let path = Bundle.main.path(forResource: "Food Served", ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let source = CGImageSourceCreateWithData(data as CFData, nil) {
            
            var images = [UIImage]()
            let count = CGImageSourceGetCount(source)
            
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: cgImage))
                }
            }
            
            imageView.animationImages = images
            imageView.animationDuration = Double(images.count) * 0.1
            imageView.animationRepeatCount = 0
            imageView.startAnimating()
        }
    }
}
