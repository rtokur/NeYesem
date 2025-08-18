//
//  ChangePasswordViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 18.08.2025.
//

import Foundation
import FirebaseAuth

final class ChangePasswordViewModel {
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func changePassword(current: String?, new: String?, confirm: String?) {
        guard let current = current, !current.isEmpty,
              let new = new, !new.isEmpty,
              let confirm = confirm, !confirm.isEmpty else {
            onError?("Lütfen tüm alanları doldurun")
            return
        }
        
        guard new == confirm else {
            onError?("Yeni şifreler eşleşmiyor")
            return
        }
        
        guard new.count >= 6 else {
            onError?("Yeni şifre en az 6 karakter olmalı")
            return
        }
        
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            onError?("Kullanıcı oturumu bulunamadı")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: current)
        
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                self?.onError?("Mevcut şifre hatalı: \(error.localizedDescription)")
                return
            }
            
            user.updatePassword(to: new) { error in
                if let error = error {
                    self?.onError?("Şifre güncellenemedi: \(error.localizedDescription)")
                    return
                }
                self?.onSuccess?()
            }
        }
    }
}
