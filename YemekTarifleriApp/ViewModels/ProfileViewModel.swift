//
//  ProfileViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

final class ProfileViewModel {
    
    private let userService: UserServiceProtocol
    var onUserDataFetched: ((UserModel) -> Void)?
    var onError: ((String) -> Void)?
    var onSignOut: (() -> Void)?
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func loadUserProfile() {
        userService.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                CoreDataManager.shared.saveUserProfile(uid: user.uid, email: user.email ?? "Bilinmiyor", username: user.displayName ?? "Bilinmiyor", photoURL: user.photoURL ?? "")
                self?.onUserDataFetched?(user)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        userService.signOut { [weak self] result in
            switch result {
            case .success:
                CoreDataManager.shared.deleteUserProfile()
                self?.onSignOut?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
