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
    func updateUserProfile(name: String?, phone: String?, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    func updateUserProfile(name: String?, phone: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "User not logged in", code: 401))); return
        }
        var data: [String: Any] = [:]
        if let name = name { data["username"] = name }
        if let phone = phone { data["phone"] = phone }
        
        db.collection("users").document(uid).setData(data, merge: true) { [weak self] err in
            if let err = err { completion(.failure(err)); return }
            if let name = name {
                let change = self?.auth.currentUser?.createProfileChangeRequest()
                change?.displayName = name
                change?.commitChanges { _ in completion(.success(())) }
            } else {
                completion(.success(()))
            }
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
