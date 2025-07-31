//
//  ForgotPasswordViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import FirebaseAuth

final class ForgotPasswordViewModel {
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthManager.shared) {
        self.authService = authService
    }
    
    func resetPassword(email: String?, completion: @escaping (String?) -> Void) {
        guard let email = email, !email.isEmpty else {
            completion("E-posta alanı boş olamaz.")
            return
        }
        
        authService.sendPasswordReset(email: email) { result in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(FirebaseAuthError.message(for: error))
            }
        }
    }
}
