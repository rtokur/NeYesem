//
//  UserManager.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import FirebaseFirestore
import FirebaseAuth

protocol UserServiceProtocol {
    func fetchCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserService: UserServiceProtocol {
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    func fetchCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "User not logged in", code: 401)))
            return
        }
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = document?.data(),
                  let user = UserModel(dictionary: data, uid: uid) else {
                completion(.failure(NSError(domain: "User data not found", code: 404)))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
