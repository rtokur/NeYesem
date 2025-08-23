//
//  ChangeEmailViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 18.08.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ChangeEmailViewModel {
    
    // MARK: - Callbacks
    var onSuccess: ((String?) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Current User Email
    var currentEmail: String? {
        return Auth.auth().currentUser?.email
    }
    
    // MARK: - Change Email
    func changeEmail(current: String?, password: String?, new: String?, confirm: String?) {
        guard let current = current, !current.isEmpty,
              let password = password, !password.isEmpty,
              let new = new, !new.isEmpty,
              let confirm = confirm, !confirm.isEmpty else {
            onError?("Please fill in all fields.")
            return
        }

        guard new == confirm else {
            onError?("New emails do not match.")
            return
        }

        guard let user = Auth.auth().currentUser else {
            onError?("User session not found.")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: current, password: password)
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                self?.onError?("Authentication error: \(error.localizedDescription)")
                return
            }

            user.sendEmailVerification(beforeUpdatingEmail: new) { error in
                if let error = error {
                    self?.onError?("Email verification error: \(error.localizedDescription)")
                    return
                }
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).updateData(["email": new]) { error in
                    if let error = error {
                        self?.onError?("Failed to update Firestore: \(error.localizedDescription)")
                        return
                    }
                    self?.onSuccess?("A verification link has been sent to your new email address. Please verify.")
                }
            }
        }
    }
}
