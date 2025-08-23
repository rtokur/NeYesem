//
//  ChangePasswordViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 18.08.2025.
//

import Foundation
import FirebaseAuth

final class ChangePasswordViewModel {
    // MARK: - Callbacks
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Change Password
    func changePassword(current: String?, new: String?, confirm: String?) {
        guard let current = current, !current.isEmpty,
              let new = new, !new.isEmpty,
              let confirm = confirm, !confirm.isEmpty else {
            onError?("Please fill in all fields.")
            return
        }
        
        guard new == confirm else {
            onError?("New passwords do not match.")
            return
        }
        
        guard new.count >= 6 else {
            onError?("New password must be at least 6 characters long.")
            return
        }
        
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            onError?("User session not found.")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: current)
        
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                self?.onError?("Current password is incorrect: \(error.localizedDescription)")
                return
            }
            
            user.updatePassword(to: new) { error in
                if let error = error {
                    self?.onError?("Password could not be updated: \(error.localizedDescription)")
                    return
                }
                self?.onSuccess?()
            }
        }
    }
}
