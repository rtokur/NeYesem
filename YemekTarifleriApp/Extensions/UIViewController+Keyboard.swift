//
//  UIViewController+Keyboard.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 27.07.2025.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String = "Uyarı",
                   message: String,
                   actionTitle: String = "Tamam",
                   completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

