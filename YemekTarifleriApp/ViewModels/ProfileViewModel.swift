//
//  ProfileViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

final class ProfileViewModel {
    
    // MARK: - Properties
    private let userService: UserServiceProtocol
    var onUserDataFetched: ((UserModel) -> Void)?
    var onError: ((String) -> Void)?
    var onSignOut: (() -> Void)?
    
    // MARK: - Init
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    // MARK: - Load User Profile
    func loadUserProfile() {
        userService.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                CoreDataManager.shared.saveUserProfile(uid: user.uid, email: user.email ?? "Bilinmiyor", name: user.name ?? "Bilinmiyor", surname: user.surname ?? "Bilinmiyor", photoURL: user.photoURL ?? "")
                self?.onUserDataFetched?(user)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Sign Out
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
