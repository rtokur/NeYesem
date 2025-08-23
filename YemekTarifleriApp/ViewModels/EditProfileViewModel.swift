//
//  EditProfileViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 11.08.2025.
//

import Foundation
import UIKit

final class EditProfileViewModel {
    // MARK: - Dependencies
    private let userService: UserServiceProtocol
    
    // MARK: - Properties
    private(set) var user: UserModel?
    
    // MARK: - Callbacks
    var onLoaded: ((UserModel) -> Void)?
    var onSaved: ((UserModel) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol = UserService(), preloadedUser: UserModel? = nil) {
        self.userService = userService
        self.user = preloadedUser
    }
    
    // MARK: - Public Methods
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
    
    func save(name: String?, surname: String?, phone: String?, image: UIImage?) {
        userService.updateUserProfile(name: name, surname: surname, phone: phone, image: image) { [weak self] result in
            switch result {
            case .failure(let e):
                self?.onError?(e.localizedDescription)
            case .success:
                self?.userService.fetchCurrentUser { fetch in
                    switch fetch {
                    case .success(let fresh):
                        self?.user = fresh
                        CoreDataManager.shared.saveUserProfile(
                            uid: fresh.uid,
                            email: fresh.email ?? "",
                            name: fresh.name ?? "",
                            surname: fresh.surname ?? "",
                            photoURL: fresh.photoURL ?? ""
                        )
                        self?.onSaved?(fresh)
                    case .failure(let e):
                        self?.onError?(e.localizedDescription)
                    }
                }
            }
        }
    }
}
