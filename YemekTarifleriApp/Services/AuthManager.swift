//
//  AuthManager.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 28.07.2025.
//

import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore
import FBSDKLoginKit

protocol AuthServiceProtocol {
    func signUp(email: String, password: String, username: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithFacebook(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    // MARK: - Email & Password Signup
    func signUp(email: String, password: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(FirebaseAuthError.unknown))
                return
            }
            
            self?.saveUserToFirestore(user: user, username: username, completion: completion)
        }
    }
    
    // MARK: - Email & Password Signin
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(FirebaseAuthError.unknown))
                return
            }
            
            self?.saveUserToFirestore(user: user, completion: completion)
        }
    }
    
    // MARK: - Google Signin
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return completion(.failure(FirebaseAuthError.missingClientID))
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let self = self,
                  let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return completion(.failure(FirebaseAuthError.invalidGoogleAuth))
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)
            
            self.auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let firebaseUser = authResult?.user else {
                    return completion(.failure(FirebaseAuthError.unknown))
                }
                
                self.saveUserToFirestore(user: firebaseUser, completion: completion)
            }
        }
    }
    
    // MARK: - Facebook Signin
    func signInWithFacebook(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: presentingVC) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result, !result.isCancelled else {
                completion(.failure(FirebaseAuthError.unknown))
                return
            }
            
            guard let tokenString = AccessToken.current?.tokenString else {
                completion(.failure(FirebaseAuthError.missingFacebookToken))
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            
            self?.auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    completion(.failure(FirebaseAuthError.unknown))
                    return
                }
                
                self?.saveUserToFirestore(user: firebaseUser, completion: completion)
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try auth.signOut()
    }
    
    // MARK: - Save User to Firestore
    private func saveUserToFirestore(user: User, username: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(user.uid)
        
        var userData: [String: Any] = [
            "email": user.email ?? "",
            "displayName": username ?? user.displayName ?? "Kullanıcı",
            "lastLogin": FieldValue.serverTimestamp()
        ]
        
        if username != nil {
            userData["createdAt"] = FieldValue.serverTimestamp()
        }
        
        userRef.setData(userData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
