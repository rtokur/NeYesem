//
//  CustomTabBar.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import UIKit

class CustomTabBar: UITabBar {
    
    //MARK: - UI Elements
    private let centerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryColor
        button.setImage(UIImage(named: "CreateRecipe"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(centerButton)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(centerButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize: CGFloat = 50
        centerButton.frame = CGRect(
            x: (bounds.width - buttonSize) / 2,
            y: 10,
            width: buttonSize,
            height: buttonSize
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height += 20 
        return size
    }
    
    //MARK: - Functions
    func setCenterButtonAction(target: Any?, action: Selector) {
        centerButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
