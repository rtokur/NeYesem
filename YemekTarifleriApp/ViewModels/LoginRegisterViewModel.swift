//
//  LOginRegisterViewm.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import Foundation

final class LoginRegisterViewModel {
    
    // MARK: - Properties
    private let authService: AuthServiceProtocol
    
    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthManager.shared) {
        self.authService = authService
    }
    
    // MARK: - Login
    func login(email: String?,
               password: String?,
               completion: @escaping (String?) -> Void) {
        
        guard let email = email,
              email != "",
              let password = password,
              password != "" else {
            completion("E-posta ve şifre boş olamaz.")
            return
        }
        
        authService.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                let firebaseError = FirebaseAuthError.message(for: error)
                completion(firebaseError)
            }
        }
    }
    
    // MARK: - Register
    func register(email: String?,
                  password: String?,
                  confirmPassword: String?,
                  completion: @escaping (String?) -> Void) {
        
        guard let email = email,
              email != "",
              let password = password,
              password != "",
              let confirmPassword = confirmPassword,
              confirmPassword != "" else {
            completion("Tüm alanlar doldurulmalıdır.")
            return
        }
        
        guard password == confirmPassword else {
            completion("Şifreler uyuşmuyor.")
            return
        }
        
        let username = email.components(separatedBy: "@").first ?? "Kullanıcı"
        
        authService.signUp(email: email, password: password, username: username) { result in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                let firebaseError = FirebaseAuthError.message(for: error)
                completion(firebaseError)
            }
        }
    }
}
