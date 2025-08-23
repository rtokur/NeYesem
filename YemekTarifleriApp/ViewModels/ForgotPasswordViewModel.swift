//
//  ForgotPasswordViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import Foundation

final class ForgotPasswordViewModel {
    // MARK: - Properties
    private let authService: AuthServiceProtocol
    
    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthManager.shared) {
        self.authService = authService
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String?, completion: @escaping (String?) -> Void) {
        guard let email = email, !email.isEmpty else {
            completion("Email field cannot be empty.")
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
