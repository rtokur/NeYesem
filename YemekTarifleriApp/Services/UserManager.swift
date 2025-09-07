//
//  UserManager.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

// MARK: - Protocol
protocol UserServiceProtocol {
    func fetchCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void)
    func updateUserProfile(name: String?, surname: String?, phone: String?, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func saveUserPreferences(diet: String?, allergies: [String], dislikes: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserService: UserServiceProtocol {
    // MARK: - Properties
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let storage = Storage.storage()
    
    // MARK: - Fetch Current User
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
    
    // MARK: - Update User Profile
    func updateUserProfile(
        name: String?,
        surname: String?,
        phone: String?,
        image: UIImage?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let uid = auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "User not logged in", code: 401)))
            return
        }
        
        var updates: [String: Any] = [:]
        if let name = name { updates["name"] = name }
        if let surname = surname { updates["surname"] = surname }
        if let phone = phone { updates["phone"] = phone }
        
        let commitChanges = {
            self.commitProfileChanges(uid: uid, updates: updates, completion: completion)
        }
        
        if let image = image, let data = image.jpegData(compressionQuality: 0.85) {
            let ref = storage.reference().child("users/\(uid)/profile.jpg")
            let meta = StorageMetadata()
            meta.contentType = "image/jpeg"
            ref.putData(data, metadata: meta) { _, error in
                if let error = error { completion(.failure(error)); return }
                ref.downloadURL { url, urlErr in
                    if let urlErr = urlErr { completion(.failure(urlErr)); return }
                    if let url = url { updates["photoURL"] = url.absoluteString }
                    commitChanges()
                }
            }
        } else {
            commitChanges()
        }
    }

    // MARK: - Commit Profile Changes
    private func commitProfileChanges(
        uid: String,
        updates: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        db.collection("users").document(uid).updateData(updates) { error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let currentUser = Auth.auth().currentUser {
                let changeRequest = currentUser.createProfileChangeRequest()
                
                if let name = updates["name"] as? String {
                    changeRequest.displayName = "\(name)"
                }
                
                if let photoURL = updates["photoURL"] as? String {
                    changeRequest.photoURL = URL(string: photoURL)
                }
                
                changeRequest.commitChanges { commitError in
                    if let commitError = commitError {
                        print("Auth profile update failed: \(commitError.localizedDescription)")
                    }
                    completion(.success(()))
                }
            } else {
                completion(.success(()))
            }
        }
    }

    
    // MARK: - Save User Preferences
    func saveUserPreferences(
        diet: String?,
        allergies: [String],
        dislikes: [String],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(
                domain: "Auth",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
            )))
            return
        }
        
        let data: [String: Any] = [
            "preferences": [
                "diet": diet ?? "",
                "allergies": allergies,
                "dislikes": dislikes
            ]
        ]
        
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData(data, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

    // MARK: - Sign Out
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

