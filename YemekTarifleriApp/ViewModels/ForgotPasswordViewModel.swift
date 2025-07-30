//
//  ForgotPasswordViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import FirebaseAuth

final class ForgotPasswordViewModel {
    
    func resetPassword(email: String?, completion: @escaping (String?) -> Void) {
        guard let email = email, !email.isEmpty else {
            completion("E-posta adresi boş olamaz.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                let errorMessage = FirebaseAuthError.message(for: error)
                completion(errorMessage)
            } else {
                completion(nil)
            }
        }
    }
}
