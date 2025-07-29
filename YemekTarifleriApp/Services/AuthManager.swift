//
//  AuthManager.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 28.07.2025.
//

import FirebaseAuth
import FirebaseFirestore

protocol AuthServiceProtocol {
    func signUp(email: String, password: String, username: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut() throws
    var currentUser: User? { get }
}

final class AuthManager: AuthServiceProtocol {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    var currentUser: User? {
        return auth.currentUser
    }

    func signUp(email: String, password: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let uid = result?.user.uid else { return }
            self?.db.collection("users").document(uid).setData([
                "email": email,
                "username": username
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signOut() throws {
        try auth.signOut()
    }
}
