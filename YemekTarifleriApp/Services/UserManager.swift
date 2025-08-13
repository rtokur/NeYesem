//
//  UserManager.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol UserServiceProtocol {
    func fetchCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void)
    func updateUserProfile(name: String?, phone: String?, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserService: UserServiceProtocol {
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let storage = Storage.storage()
    
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
    
    func updateUserProfile(name: String?, phone: String?, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "User not logged in", code: 401))); return
        }
        
        // Firestore’a yazılacak alanlar
        var updates: [String: Any] = [:]
        if let name = name { updates["username"] = name }
        if let phone = phone { updates["phone"] = phone }
        
        // 🔹 Görsel varsa önce Storage’a yükle
        if let image = image, let data = image.jpegData(compressionQuality: 0.85) {
            let ref = storage.reference().child("users/\(uid)/profile.jpg")
            let meta = StorageMetadata(); meta.contentType = "image/jpeg"
            ref.putData(data, metadata: meta) { [weak self] _, error in
                if let error = error { completion(.failure(error)); return }
                ref.downloadURL { url, urlErr in
                    if let urlErr = urlErr { completion(.failure(urlErr)); return }
                    if let url = url { updates["photoURL"] = url.absoluteString }
                    self?.commitProfileChanges(uid: uid, updates: updates, photoURL: updates["photoURL"] as? String, name: name, completion: completion)
                }
            }
        } else {
            // 🔹 Görsel yoksa sadece metin alanlarını güncelle
            commitProfileChanges(uid: uid, updates: updates, photoURL: nil, name: name, completion: completion)
        }
    }
    
    private func commitProfileChanges(uid: String,
                                      updates: [String: Any],
                                      photoURL: String?,
                                      name: String?,
                                      completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(uid).setData(updates, merge: true) { [weak self] err in
            if let err = err { completion(.failure(err)); return }
            
            // Auth profile (isteğe bağlı ama güzel)
            if let current = self?.auth.currentUser {
                let change = current.createProfileChangeRequest()
                if let name = name { change.displayName = name }
                if let photoURL = photoURL, let url = URL(string: photoURL) { change.photoURL = url }
                change.commitChanges { _ in completion(.success(())) }
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

