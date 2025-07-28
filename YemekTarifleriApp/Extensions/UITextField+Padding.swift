//
//  UITextField+Padding.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 27.07.2025.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func applyDefaultStyle(placeholder: String) {
        self.layer.borderColor = UIColor.textColor300.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.font = UIFont.dmSansRegular(16)
        self.textColor = UIColor.textColor900
        self.tintColor = UIColor.textColor400
        self.autocapitalizationType = .none
        
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.textColor300,
                .font: UIFont.dmSansRegular(16)
            ]
        )
        self.setLeftPadding(17)
    }
    
    func setActiveBorder() {
        self.layer.borderColor = UIColor.primaryColor.cgColor
        self.layer.borderWidth = 1.5
    }
    
    func setInactiveBorder() {
        self.layer.borderColor = UIColor.textColor300.cgColor
        self.layer.borderWidth = 1
    }
}


