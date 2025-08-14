//
//  EditProfileViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 11.08.2025.
//

import Foundation
import FirebaseAuth
import UIKit

final class EditProfileViewModel {
    private let userService: UserServiceProtocol
    private(set) var user: UserModel?
    
    var onLoaded: ((UserModel) -> Void)?
    var onSaved: ((UserModel) -> Void)?
    var onError: ((String) -> Void)?
    
    init(userService: UserServiceProtocol = UserService(), preloadedUser: UserModel? = nil) {
        self.userService = userService
        self.user = preloadedUser
    }
    
    func load() {
        if let user = user {
            onLoaded?(user)
            return
        }
        userService.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let user): self?.user = user; self?.onLoaded?(user)
            case .failure(let error): self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func save(name: String?, phone: String?, image: UIImage?) {
        userService.updateUserProfile(name: name, phone: phone, image: image) { [weak self] result in
            switch result {
            case .failure(let e):
                self?.onError?(e.localizedDescription)
            case .success:
                self?.userService.fetchCurrentUser { fetch in
                    switch fetch {
                    case .success(let fresh):
                        self?.user = fresh
                        CoreDataManager.shared.saveUserProfile(uid: fresh.uid,
                                                               email: fresh.email ?? "",
                                                               username: fresh.displayName ?? "",
                                                               photoURL: fresh.photoURL ?? "")
                        self?.onSaved?(fresh)
                    case .failure(let e):
                        self?.onError?(e.localizedDescription)
                    }
                }
            }
        }
    }
}
