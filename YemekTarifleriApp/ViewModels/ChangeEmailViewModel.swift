//
//  ChangeEmailViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 18.08.2025.
//

import Foundation
import FirebaseAuth

final class ChangeEmailViewModel {
    var onSuccess: ((String?) -> Void)?
    var onError: ((String) -> Void)?
    
    var currentEmail: String? {
        return Auth.auth().currentUser?.email
    }
    
    func changeEmail(current: String?, password: String?, new: String?, confirm: String?) {
        guard let current = current, !current.isEmpty,
              let password = password, !password.isEmpty,
              let new = new, !new.isEmpty,
              let confirm = confirm, !confirm.isEmpty else {
            onError?("Lütfen tüm alanları doldurun")
            return
        }

        guard new == confirm else {
            onError?("Yeni e-postalar eşleşmiyor")
            return
        }

        guard let user = Auth.auth().currentUser else {
            onError?("Kullanıcı oturumu bulunamadı")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: current, password: password)
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                self?.onError?("Kimlik doğrulama hatası: \(error.localizedDescription)")
                return
            }

            user.sendEmailVerification(beforeUpdatingEmail: new) { error in
                if let error = error {
                    self?.onError?("E-posta doğrulama hatası: \(error.localizedDescription)")
                    return
                }
                self?.onSuccess?("Yeni e-posta adresinize doğrulama linki gönderildi. Lütfen doğrulayın.")
            }
        }
    }
}
